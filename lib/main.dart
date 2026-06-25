import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'config/supabase_config.dart';
import 'app.dart';
import 'services/notification_service.dart';
import 'services/ad_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final splashStart = DateTime.now();

  tz.initializeTimeZones();

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    ).timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('[Main] Supabase init failed: $e');
  }

  try {
    await NotificationService.initPlugin().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('[Main] Notification init failed: $e');
  }

  final elapsed = DateTime.now().difference(splashStart);
  const minSplash = Duration(seconds: 2);
  if (elapsed < minSplash) {
    await Future.delayed(minSplash - elapsed);
  }

  FlutterNativeSplash.remove();

  // 스플래시 제거 후 백그라운드 초기화
  _initBackground();

  runApp(const StreaklyApp());
}

void _initBackground() {
  Future(() async {
    try {
      await AdService().initialize().timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('[Main] AdService init failed: $e');
    }
    try {
      await NotificationService.requestPermission();
    } catch (e) {
      debugPrint('[Main] Notification permission failed: $e');
    }
  });
}
