class SupabaseConfig {
  static const String url = 'https://wdlkfsaebulldwwsgmxm.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkbGtmc2FlYnVsbGR3d3NnbXhtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyNDc5MjgsImV4cCI6MjA5NTgyMzkyOH0.HGWvpGzM80giEpm25ZKQRLwL6iNaEw0KPkpIhMDW1RY';

  // TODO: Google Cloud Console → APIs & Services → Credentials → iOS OAuth 2.0 Client ID
  // 형식: XXXXXXXXXX-xxxxxxxxxxxx.apps.googleusercontent.com
  static const String googleIosClientId =
      '1024221864426-6b2l6d8roj0r6jtijlccqg9du5vk8j8k.apps.googleusercontent.com';

  // Google Cloud Console → APIs & Services → Credentials → Web 애플리케이션 OAuth Client ID
  // Supabase Google Provider에 등록된 Client ID와 동일해야 함
  static const String googleWebClientId =
      '1024221864426-bi7j5rptdb2inbpsv6so7tm3uga0gka6.apps.googleusercontent.com';

  // OAuth 웹 플로우 딥링크 콜백 URL.
  // Supabase → Authentication → URL Configuration → Redirect URLs 에 등록되어야 하며,
  // iOS Info.plist의 CFBundleURLSchemes / Android Manifest의 intent-filter와 일치해야 함.
  static const String oauthRedirectUrl = 'kr.dotone.streakly://login-callback/';
}
