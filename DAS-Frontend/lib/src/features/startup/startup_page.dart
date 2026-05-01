import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_pm/src/core/database/seed_service.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';

// ignore: unused_import
import 'dart:async';

@RoutePage()
class StartupPage extends ConsumerStatefulWidget {
  const StartupPage({super.key});

  @override
  ConsumerState<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends ConsumerState<StartupPage>
    with SingleTickerProviderStateMixin {
  bool _showSkipButton = false;
  bool _isInitializing = true;
  Timer? _skipTimer;

  late AnimationController _animationController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();

    _initialize();

    // Show manual skip button if initialization takes longer than 3 seconds
    _skipTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSkipButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _skipTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    debugPrint('🔵 StartupPage: Beginning Initialization Sequence...');

    try {
      // 1. Seed Database with Timeout (skip for web - uses API backend)
      if (!kIsWeb) {
        debugPrint('🔵 StartupPage: Seeding local database...');
        final seedService = ref.read(seedServiceProvider);

        await Future.any([
          seedService.seedData(),
          Future.delayed(const Duration(seconds: 5), () {
            throw TimeoutException('Database seeding timed out');
          }),
        ]);

        debugPrint('✅ StartupPage: Database seeded successfully');
      } else {
        debugPrint(
            'ℹ️ StartupPage: Web build detected - skipping local DB seeding');
      }

      // 2. Wait for auth state to initialize (handles session restore and HRM SSO)
      // We add a 10-second timeout here to prevent a permanent "white screen"
      // if the SSO validation hangs or the network is slow.
      debugPrint(
          '🔵 StartupPage: Awaiting authentication resolution (10s timeout)...');

      final authState = await ref.read(authNotifierProvider.future).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint(
              '⚠️ StartupPage: Authentication resolution timed out after 10s');
          // Fall back to a default unauthenticated state to allow navigation to login
          return const AuthState();
        },
      );

      debugPrint(
          '✅ StartupPage: Auth settled - isAuthenticated: ${authState.isAuthenticated}');

      if (authState.isAuthenticated) {
        debugPrint(
            '🚀 StartupPage: User authenticated, navigating to dashboard');
        if (mounted) _navigateToDashboard();
        return;
      }

      // 3. If not authenticated, still navigate to dashboard
      // (ShellPage will redirect to /login if not authenticated)
      if (mounted) {
        debugPrint(
            'ℹ️ StartupPage: Not authenticated, moving to protected route/shell');
        _navigateToDashboard();
      }
    } catch (e) {
      debugPrint('❌ StartupPage: Initialization error: $e');
      if (mounted) {
        _navigateToDashboard(); // Try to navigate anyway to let ShellPage handle it
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to navigate reactively
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenData((authState) {
        if (authState.isAuthenticated && mounted && !_isNavigating) {
          debugPrint(
              'StartupPage: Auth state changed to authenticated, navigating instantly...');
          _navigateToDashboard();
        }
      });
    });

    // Determine if we are currently in an auto-login process
    final isAuthenticating =
        ref.watch(authNotifierProvider).isLoading || _isInitializing;

    // We stay on the logo/welcome screen until the router actually replaces this page.
    // This prevents the "blinking" effect where a bare spinner screen flashes
    // for a few frames during the transition.
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Full Logo Display (No Clipping)
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      height: 180, // Larger height for full logo
                      width: 300, // Wider for rectangle logos
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          fit: BoxFit.contain, // Show full logo
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Welcome Text Animation
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      children: [
                        Text(
                          'Welcome to DAS',
                          style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 1.2,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Subtle Spinner
                FadeTransition(
                  opacity: _textFade,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: isAuthenticating
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                          )
                        : (_showSkipButton
                            ? OutlinedButton.icon(
                                onPressed: _navigateToDashboard,
                                icon: const Icon(Icons.skip_next),
                                label: const Text('Entering Dashboard...'),
                              )
                            : const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.grey),
                              )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateToDashboard() {
    if (!mounted || _isNavigating) return;
    _isNavigating = true;
    _skipTimer?.cancel();
    debugPrint('🔵 StartupPage: Triggering navigation to ShellPage/Dashboard');
    context.router.replace(const ShellRoute(children: [DashboardRoute()]));
  }
}
