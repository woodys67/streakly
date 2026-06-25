import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../theme/app_theme.dart';

class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _ad;
  bool _loaded = false;

  static String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7794167160748856/3780859686';
    }
    return 'ca-app-pub-7794167160748856/1238456829';
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _ad = NativeAd(
      adUnitId: _adUnitId,
      factoryId: 'adFactorySmall',
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[NativeAd] 로드 실패 (code=${error.code}): ${error.message}');
          ad.dispose();
          if (!mounted) return;
          setState(() => _ad = null);
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorOutline, width: 1.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: AdWidget(ad: _ad!),
    );
  }
}
