import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7794167160748856/8322739924';
    }
    return 'ca-app-pub-7794167160748856/1234587398';
  }

  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['82F1319C316ECC5A63C1B7FA65FE074B']),
    );
    loadRewardedAd();
  }

  void loadRewardedAd() {
    if (_isLoading || _rewardedAd != null) return;
    _isLoading = true;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          debugPrint('[AdService] 보상형 광고 로드 완료');
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] 광고 로드 실패: $error');
          _isLoading = false;
        },
      ),
    );
  }

  bool get isRewardedAdReady => _rewardedAd != null;

  // 광고 시청 완료 시 true, 미완료/실패 시 false 반환
  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) {
      loadRewardedAd();
      return false;
    }

    final completer = Completer<bool>();
    bool rewarded = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        if (!completer.isCompleted) completer.complete(rewarded);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdService] 광고 표시 실패: $error');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
      },
    );

    return completer.future;
  }
}
