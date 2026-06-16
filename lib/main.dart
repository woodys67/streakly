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

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  await NotificationService.init();
  await AdService().initialize();

  final elapsed = DateTime.now().difference(splashStart);
  const minSplash = Duration(seconds: 2);
  if (elapsed < minSplash) {
    await Future.delayed(minSplash - elapsed);
  }

  FlutterNativeSplash.remove();
  runApp(const StreaklyApp());
}
