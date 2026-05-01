import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pm/src/features/auth/auth_state_providers.dart';
import 'dart:html' as html show window;

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  // MERIDA DAS Brand Colors
  static const Color _brandDark = Color(0xFF0A0E2A); // Deep Navy
  static const Color _brandPrimary = Color(0xFF1B3FA0); // Royal Blue
  static const Color _brandAccent = Color(0xFF4F8EF7); // Vivid Blue
  static const Color _brandSurface = Color(0xFFF7F9FF); // Soft white-blue

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();

    // Check for HRM SSO code in URL params (fallback if startup page missed it)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = Uri.parse(html.window.location.href);
      final queryParams = uri.queryParameters;
      if (queryParams.containsKey('code') && queryParams.containsKey('email')) {
        _handleHrmAutoLogin(queryParams['code']!, queryParams['email']!);
      }
    });
  }

  Future<void> _handleHrmAutoLogin(String code, String email) async {
    try {
      final response = await ref
          .read(authNotifierProvider.notifier)
          .autoLoginWithHRMCode(code: code, email: email);

      if (!mounted) return;

      if (response['success'] == true) {
        // Clean URL and go to dashboard
        final uri = Uri.parse(html.window.location.href);
        final cleanUrl = uri.replace(queryParameters: {}).toString();
        html.window.history.replaceState(null, '', cleanUrl);
        context.router.replaceNamed('/app/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Auto-login failed: ${response['error']}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Auto-login error: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    if (authState.valueOrNull?.isAuthenticated == true) {
      context.router.replaceNamed('/app/dashboard');
    } else if (authState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authState.error.toString().replaceAll('Exception: ', ''),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brandSurface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  // ─── DESKTOP ──────────────────────────────────────────────────────────────

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left – Hero / Branding Panel
        const Expanded(
          flex: 5,
          child: _HeroBrandPanel(),
        ),
        // Right – Login Form
        Expanded(
          flex: 4,
          child: Container(
            color: const Color(0xFFF8FAFC),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 56, vertical: 40),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                            BoxShadow(
                              color: const Color(0xFF3B82F6)
                                  .withValues(alpha: 0.05),
                              blurRadius: 10,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: _buildLoginForm(),
                      ).animate().shimmer(
                          duration: 5.seconds,
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── MOBILE ───────────────────────────────────────────────────────────────

  Widget _buildMobileLayout() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Compact brand header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_brandDark, _brandPrimary],
                ),
              ),
              child: const Column(
                children: [
                  _DasLogo(size: 85),
                  SizedBox(height: 16),
                  _DasWordmark(light: true, compact: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildLoginForm(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── LOGIN FORM ───────────────────────────────────────────────────────────

  Widget _buildLoginForm() {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting
          Text(
            'Welcome to DAS',
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: _brandDark,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The next generation of team coordination.',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 36),

          // Email
          _buildLabel('Email Address'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'you@merida.com',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password
          _buildLabel('Password'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _passwordController,
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade400,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              return null;
            },
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: _brandAccent,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Sign In button
          _SignInButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : _handleLogin,
            primaryColor: _brandPrimary,
            accentColor: _brandAccent,
          ),

          const SizedBox(height: 24),

          // Sign Up row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500, fontSize: 13),
              ),
              GestureDetector(
                onTap: () => context.router.replaceNamed('/signup'),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    color: _brandPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Footer branding
          Center(
            child: Text(
              '© 2025 DAS Ecosystem. All rights reserved.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF111827),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon:
            Icon(icon, color: _brandPrimary.withValues(alpha: 0.6), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF3F4F6).withValues(alpha: 0.5),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _brandAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}

// ─── HERO BRAND PANEL ────────────────────────────────────────────────────────

class _HeroBrandPanel extends StatelessWidget {
  const _HeroBrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A), // Deep Slate
            Color(0xFF1E293B), // Slate
            Color(0xFF1E40AF), // Deep Blue
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated Background Elements
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(
                painter: _AtmosphericPainter(),
              ),
            ),
          ),
          // Subtle Particle-like spheres
          const Positioned(
            top: -150,
            right: -100,
            child: _GlowCircle(size: 600, color: Color(0xFF1E40AF)),
          ),
          const Positioned(
            bottom: -100,
            left: -100,
            child: _GlowCircle(size: 400, color: Color(0xFF1E3A8A)),
          ),
          const Positioned(
            top: 200,
            left: 60,
            child: _GlowCircle(size: 120, color: Color(0xFF4F8EF7)),
          ),

          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo row
                  const Row(
                    children: [
                      _DasLogo(size: 75),
                      SizedBox(width: 16),
                      _DasWordmark(light: true, compact: false),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // Hero copy
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Activity\nScheduler',
                          style: GoogleFonts.poppins(
                            fontSize: 46,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Plan smarter, execute faster.\nTrack your team\'s daily activities, tasks, and goals — all in one place.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.72),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const _FeaturePill(
                            icon: Icons.task_alt_rounded,
                            label: 'Task Management'),
                        const SizedBox(height: 10),
                        const _FeaturePill(
                            icon: Icons.bar_chart_rounded,
                            label: 'Activity Analytics'),
                        const SizedBox(height: 10),
                        const _FeaturePill(
                            icon: Icons.groups_rounded,
                            label: 'Team Collaboration'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Bottom tagline
                  Text(
                    'Trusted by modern engineering teams',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.45),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── DAS LOGO ICON ───────────────────────────────────────────────────────────

class _DasLogo extends StatelessWidget {
  final double size;
  const _DasLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.5,
      height: size * 1.5,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Multi-layered Cinematic Glow
              ...List.generate(
                  3,
                  (i) => Container(
                        width: size * (1.1 + (i * 0.1)),
                        height: size * (1.1 + (i * 0.1)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: [
                                const Color(0xFF3B82F6).withValues(alpha: 0.15),
                                const Color(0xFF60A5FA).withValues(alpha: 0.1),
                                const Color(0xFF2563EB).withValues(alpha: 0.05),
                              ][i],
                              blurRadius: 20 + (i * 15),
                              spreadRadius: 2 + (i * 5),
                            ),
                          ],
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                          begin: Offset(0.95 + (i * 0.02), 0.95 + (i * 0.02)),
                          end: Offset(1.05 + (i * 0.05), 1.05 + (i * 0.05)),
                          duration: (2 + i).seconds,
                          curve: Curves.easeInOut)),

              // Premium Tech Ring
              Container(
                width: size,
                height: size,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const SweepGradient(
                    colors: [
                      Color(0xFF00D2FF),
                      Color(0xFF3A7BD5),
                      Color(0xFF00D2FF),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).rotate(duration: 4.seconds),

              // Glassmorphic Inner Core
              Container(
                width: size * 0.88,
                height: size * 0.88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // The Logo Image - using cover for professional edge-to-edge look
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo.jpeg',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.psychology_outlined,
                                size: size * 0.4,
                                color: const Color(0xFF0A0E2A)),
                          );
                        },
                      ),
                    ),
                    // Subtle Vignette / Inner Shadow for depth
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.15),
                          ],
                          stops: const [0.7, 1.0],
                        ),
                      ),
                    ),
                    // Inner Tech Ring detail
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                        duration: 3.seconds,
                        color: Colors.white.withValues(alpha: 0.4))
                    .shimmer(
                        duration: 5.seconds,
                        delay: 1.seconds,
                        color: Colors.blue.withValues(alpha: 0.2)),
              ),
            ],
          ),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
          begin: -5, end: 5, duration: 3.seconds, curve: Curves.easeInOut),
    );
  }
}

// ─── DAS WORDMARK ────────────────────────────────────────────────────────────

class _DasWordmark extends StatelessWidget {
  final bool light;
  final bool compact;
  const _DasWordmark({required this.light, required this.compact});

  @override
  Widget build(BuildContext context) {
    final textColor = light ? Colors.white : const Color(0xFF0A0E2A);
    final subColor =
        light ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF6B7280);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'MERIDA ',
                style: GoogleFonts.inter(
                  fontSize: compact ? 22 : 28,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: 1.5,
                ),
              ),
              WidgetSpan(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF00F2FE), // Cyan
                      Color(0xFF4FACFE), // Blue
                      Color(0xFF764BA2), // Purple
                      Color(0xFFF59E0B), // Orange
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'DAS',
                    style: GoogleFonts.orbitron(
                      fontSize: compact ? 22 : 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(
                    duration: 3.seconds,
                    color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),
        Text(
          'Daily Activity Scheduler',
          style: GoogleFonts.inter(
            fontSize: compact ? 11 : 14,
            fontWeight: FontWeight.w500,
            color: subColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ─── SIGN IN BUTTON ───────────────────────────────────────────────────────────

class _SignInButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color primaryColor;
  final Color accentColor;

  const _SignInButton({
    required this.isLoading,
    required this.onPressed,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<_SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<_SignInButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _hovered
                ? [widget.accentColor, widget.primaryColor]
                : [widget.primaryColor, const Color(0xFF163490)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  widget.primaryColor.withValues(alpha: _hovered ? 0.45 : 0.3),
              blurRadius: _hovered ? 25 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SIGN IN',
                            style: GoogleFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.bolt_rounded,
                              color: Colors.white, size: 20),
                        ],
                      ).animate(onPlay: (c) => c.repeat()).shimmer(
                        duration: 3.seconds,
                        color: Colors.white.withValues(alpha: 0.3)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── FEATURE PILL ─────────────────────────────────────────────────────────────

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: const Color(0xFFF5A623)),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── GLOW CIRCLE ─────────────────────────────────────────────────────────────

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class _AtmosphericPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    const spacing = 50.0;
    // Grid with subtle perspective vibe
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Ambient "Points of Light"
    final pointPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.3), 2, pointPaint);
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.15), 3, pointPaint);
    canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.7), 1.5, pointPaint);
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.85), 2.5, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
