import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/badge_provider.dart';
import 'providers/challenge_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/auth/landing_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/challenge/challenge_screen.dart';
import 'screens/records/records_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'widgets/badge_unlock_dialog.dart';
import 'widgets/bottom_nav.dart';

class StreaklyApp extends StatelessWidget {
  const StreaklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BadgeProvider()),
        ChangeNotifierProxyProvider<BadgeProvider, ChallengeProvider>(
          create: (_) => ChallengeProvider(),
          update: (_, badge, challenge) => challenge!..setBadgeProvider(badge),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Streakly',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const _AppInitializer(),
          );
        },
      ),
    );
  }
}

class _AppInitializer extends StatefulWidget {
  const _AppInitializer();

  @override
  State<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  bool _initialized = false;
  bool _seenOnboarding = false;
  bool _prevAuthenticated = false;
  AuthProvider? _authProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_authListener);
    super.dispose();
  }

  void _authListener() {
    final auth = _authProvider;
    if (auth == null) return;
    if (_prevAuthenticated && !auth.isAuthenticated) {
      _onSignedOut();
    }
    _prevAuthenticated = auth.isAuthenticated;
  }

  Future<void> _onSignedOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('has_seen_onboarding');
    if (mounted) setState(() => _seenOnboarding = false);
  }

  Future<void> _initialize() async {
    final auth = context.read<AuthProvider>();
    final challenges = context.read<ChallengeProvider>();
    final settings = context.read<SettingsProvider>();
    final badges = context.read<BadgeProvider>();

    final prefs = await SharedPreferences.getInstance();
    _seenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    await Future.wait([
      challenges.loadChallenges(),
      settings.loadSettings(),
      badges.load(),
    ]);
    if (mounted) {
      _authProvider = auth;
      _prevAuthenticated = auth.isAuthenticated;
      auth.addListener(_authListener);
      setState(() => _initialized = true);
    }
  }

  Future<void> _handleGuestContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) setState(() => _seenOnboarding = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/flame.png', width: 56, height: 56),
              const SizedBox(height: 16),
              const Text(
                'Streakly',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
      );
    }

    final auth = context.watch<AuthProvider>();

    if (auth.isAuthenticated || _seenOnboarding) {
      return const _MainNavigation();
    }

    return LandingScreen(onContinueAsGuest: _handleGuestContinue);
  }
}

class _MainNavigation extends StatefulWidget {
  const _MainNavigation();

  @override
  State<_MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<_MainNavigation> {
  int _currentIndex = 0;
  bool _showingBadgeDialog = false;

  static const List<Widget> _screens = [
    HomeScreen(),
    ChallengeScreen(),
    RecordsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BadgeProvider>().addListener(_onBadgeUpdate);
    });
  }

  @override
  void dispose() {
    context.read<BadgeProvider>().removeListener(_onBadgeUpdate);
    super.dispose();
  }

  void _onBadgeUpdate() {
    if (!mounted) return;
    final bp = context.read<BadgeProvider>();
    if (bp.hasPendingUnlock && !_showingBadgeDialog) {
      setState(() => _showingBadgeDialog = true);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => BadgeUnlockDialog(
          badge: bp.nextUnlock!,
          onDismiss: () {
            Navigator.of(context).pop();
            bp.consumeNextUnlock();
            if (mounted) setState(() => _showingBadgeDialog = false);
          },
        ),
      ).then((_) {
        if (mounted) setState(() => _showingBadgeDialog = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: StreaklyBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
