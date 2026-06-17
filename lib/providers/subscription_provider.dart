import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kIsPremium = 'is_premium';
const _kPlanType = 'plan_type'; // 'monthly' | 'annual'

class SubscriptionProvider extends ChangeNotifier {
  bool _isPremium = false;
  String _planType = '';

  bool get isPremium => _isPremium;
  String get planType => _planType;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_kIsPremium) ?? false;
    _planType = prefs.getString(_kPlanType) ?? '';
    notifyListeners();
  }

  /// 구독 활성화 (실제 IAP 연동 전 mock 구현)
  Future<void> subscribe(String plan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremium, true);
    await prefs.setString(_kPlanType, plan);
    _isPremium = true;
    _planType = plan;
    notifyListeners();
  }

  /// 구독 해지 (테스트 및 복원 실패 시 사용)
  Future<void> cancel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremium, false);
    await prefs.remove(_kPlanType);
    _isPremium = false;
    _planType = '';
    notifyListeners();
  }
}
