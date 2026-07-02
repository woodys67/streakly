import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kIsPremium = 'is_premium';
const _kPlanType = 'plan_type'; // 'monthly' | 'annual'

/// 앱스토어 / 플레이스토어에 등록된 상품 ID
const kProductMonthly = 'kr.dotone.streakly.pro.monthly';
const kProductAnnual  = 'kr.dotone.streakly.pro.annual';

/// 구독 검증을 건너뛰는 테스트 계정 이메일 목록.
/// 실제 IAP 연동 후에도 이 계정들은 항상 Pro로 동작한다.
const _kTestAccounts = <String>{
  'hwsong67@gmail.com',
  'test@streakly.app',
};

class SubscriptionProvider extends ChangeNotifier {
  bool _isPremium = false;
  String _planType = '';
  String? _currentEmail;

  bool _isStoreAvailable = false;
  List<ProductDetails> _products = [];
  List<String> _notFoundIds = [];
  String? _queryError;
  bool _isLoading = false;
  String? _purchaseError;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  // ── Getters ─────────────────────────────────────────────────────────────────

  /// 테스트 계정이면 결제 여부와 무관하게 Pro로 취급
  bool get isPremium => _isPremium || _isTestAccount;

  bool get _isTestAccount =>
      _currentEmail != null && _kTestAccounts.contains(_currentEmail);

  /// 설정 화면에서 플랜명 표시용 (테스트 계정도 'test'로 구분)
  String get planType => _isTestAccount ? 'test' : _planType;

  bool get isStoreAvailable => _isStoreAvailable;
  bool get isLoading => _isLoading;
  String? get purchaseError => _purchaseError;
  List<ProductDetails> get products => _products;

  /// 진단용: 상품 조회 상태 요약 (설정/구독 화면에서 원인 파악)
  String get diagnostics {
    if (!_isStoreAvailable) return 'Store 사용 불가 (isAvailable=false)';
    final buf = StringBuffer('상품 ${_products.length}개 로드');
    if (_notFoundIds.isNotEmpty) buf.write(' · 미발견: ${_notFoundIds.join(", ")}');
    if (_queryError != null) buf.write(' · 오류: $_queryError');
    return buf.toString();
  }

  ProductDetails? get monthlyProduct =>
      _products.where((p) => p.id == kProductMonthly).firstOrNull;
  ProductDetails? get annualProduct =>
      _products.where((p) => p.id == kProductAnnual).firstOrNull;

  // ── 로그인/로그아웃 연동 ─────────────────────────────────────────────────────

  /// app.dart 에서 인증 상태 변경 시 호출
  void setCurrentEmail(String? email) {
    _currentEmail = email?.trim().toLowerCase();
    notifyListeners();
  }

  // ── 초기화 ───────────────────────────────────────────────────────────────────

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // 레거시 정리: 실제 IAP 전환 이전의 mock subscribe()가 결제 없이 저장한
    // is_premium 플래그를 1회 제거한다. 이후 _isPremium은 실제 결제(_deliver)
    // 또는 restorePurchases() 로만 true가 된다.
    const kIapMigrationV1 = 'iap_migration_v1_done';
    if (!(prefs.getBool(kIapMigrationV1) ?? false)) {
      await prefs.remove(_kIsPremium);
      await prefs.remove(_kPlanType);
      await prefs.setBool(kIapMigrationV1, true);
    }

    // 로컬 캐시 먼저 적용 (빠른 UI 표시)
    _isPremium = prefs.getBool(_kIsPremium) ?? false;
    _planType  = prefs.getString(_kPlanType) ?? '';
    notifyListeners();

    await _initStore();
  }

  Future<void> _initStore() async {
    _isStoreAvailable = await InAppPurchase.instance.isAvailable();
    if (!_isStoreAvailable) {
      notifyListeners();
      return;
    }

    // 구매 스트림 구독
    _purchaseSub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object e) {
        _purchaseError = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );

    // 상품 목록 조회
    await _queryProducts();

    // 기존 구독 복원 (앱 재설치 / 기기 변경 대응)
    await InAppPurchase.instance.restorePurchases();
  }

  Future<void> _queryProducts() async {
    try {
      final response = await InAppPurchase.instance.queryProductDetails(
        {kProductMonthly, kProductAnnual},
      );
      _products = response.productDetails;
      _notFoundIds = response.notFoundIDs;
      _queryError = response.error?.message;
      if (kDebugMode) {
        debugPrint('[IAP] 상품 ${_products.length}개 로드: '
            '${_products.map((p) => "${p.id}=${p.price}").join(", ")}');
        if (_notFoundIds.isNotEmpty) {
          debugPrint('[IAP] 미발견 상품 ID: ${_notFoundIds.join(", ")}');
        }
        if (_queryError != null) debugPrint('[IAP] 조회 오류: $_queryError');
      }
    } catch (e) {
      _queryError = e.toString();
      if (kDebugMode) debugPrint('[IAP] queryProductDetails 예외: $e');
    }
    notifyListeners();
  }

  // ── 구매 스트림 처리 ─────────────────────────────────────────────────────────

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _isLoading = true;
          _purchaseError = null;
          notifyListeners();

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _deliver(purchase);
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          }

        case PurchaseStatus.error:
          _purchaseError = purchase.error?.message;
          _isLoading = false;
          notifyListeners();

        case PurchaseStatus.canceled:
          _isLoading = false;
          notifyListeners();
      }
    }
  }

  Future<void> _deliver(PurchaseDetails purchase) async {
    final plan = purchase.productID == kProductAnnual ? 'annual' : 'monthly';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremium, true);
    await prefs.setString(_kPlanType, plan);
    _isPremium = true;
    _planType  = plan;
    _isLoading = false;
    _purchaseError = null;
    notifyListeners();
  }

  // ── 공개 액션 ─────────────────────────────────────────────────────────────────

  /// 구독 구매 시작 (상품 ID 기준)
  Future<void> subscribe(String plan) async {
    final product = plan == 'annual' ? annualProduct : monthlyProduct;
    if (product == null) {
      // 상품을 못 불러온 경우 원인을 화면에 표시
      _purchaseError = '상품을 불러올 수 없습니다.\n$diagnostics';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _purchaseError = null;
    notifyListeners();

    final param = PurchaseParam(productDetails: product);
    // 구독은 non-consumable로 처리
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  /// 기존 구매 복원 (iOS App Store 가이드라인 필수)
  Future<void> restorePurchases() async {
    _isLoading = true;
    _purchaseError = null;
    notifyListeners();
    await InAppPurchase.instance.restorePurchases();
    // 결과는 purchaseStream → _onPurchaseUpdate 에서 처리됨
    // 복원 완료 후 로딩 해제는 스트림에서 처리되므로 여기서는 타임아웃 대비만
    await Future<void>.delayed(const Duration(seconds: 3));
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 구독 관리 페이지 URL (OS 스토어로 이동)
  String get manageSubscriptionUrl => Platform.isIOS
      ? 'https://apps.apple.com/account/subscriptions'
      : 'https://play.google.com/store/account/subscriptions?sku=$kProductMonthly&package=kr.dotone.streakly';

  /// 로컬 캐시 초기화 (로그아웃 / 환불 후 사용)
  Future<void> clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremium, false);
    await prefs.remove(_kPlanType);
    _isPremium = false;
    _planType  = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }
}
