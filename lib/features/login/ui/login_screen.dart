// features/login/ui/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/helper/extentation.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/features/login/logic/login_cubit.dart';
import 'package:tabiby/features/login/logic/login_state.dart';
import 'package:tabiby/features/login/ui/forget_password.dart';

import 'widgets/login_header.dart';
import 'widgets/login_form_card.dart';
import 'widgets/signup_prompt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setStatusBar();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            rememberMe: _rememberMe,
          );
    }
  }

  void _handleGoogleLogin() {
    context.read<LoginCubit>().signInWithGoogle();
  }

  void _handleAppleLogin() {
    context.read<LoginCubit>().signInWithApple();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: _handleStateChanges,
          child: _buildBody(),
        ),
      ),
    );
  }


  void _handleStateChanges(BuildContext context, LoginState state) {
  if (state is LoginError) {
    _showSnackbar(
      context,
      message: state.message,
      icon: Icons.error_rounded,
      color: const Color(0xFFDC2626),
    );
  } else if (state is LoginSuccess) {
    _showSnackbar(
      context,
      message: 'تم تسجيل الدخول بنجاح',
      icon: Icons.check_circle_rounded,
      color: const Color(0xFF059669),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      context.pushNamedAndRemoveUntil(Routes.homeScreen, predicate: (Route<dynamic> route) { 
        return false;
       });
    });
  } else if (state is LoginPasswordResetOTPRequired) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgetPasswordScreen(),
      ),
    );
  } else if (state is LoginPasswordResetOTPSent) {
    _showSnackbar(
      context,
      message: state.message,
      icon: Icons.email_outlined,
      color: const Color(0xFF1E40AF),
    );
  } else if (state is LoginPasswordResetSuccess) {
    _showSnackbar(
      context,
      message: 'تم إعادة تعيين كلمة المرور بنجاح',
      icon: Icons.check_circle_rounded,
      color: const Color(0xFF059669),
    );
  } else if (state is LoginEmailVerificationSuccess) {
    _showSnackbar(
      context,
      message: 'تم التحقق من البريد الإلكتروني بنجاح',
      icon: Icons.verified_rounded,
      color: const Color(0xFF059669),
    );
  }
}
  void _showSnackbar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            Gap(12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
        elevation: 3,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 768;
        final isSmallScreen = constraints.maxHeight < 700;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 500.w : double.infinity,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: isSmallScreen ? 24.h : 40.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isSmallScreen) Gap(20.h),
                    LoginHeader(
                      fadeAnimation: _fadeAnimation,
                    ),
                    Gap(isSmallScreen ? 32.h : 48.h),
                    LoginFormCard(
                      fadeAnimation: _fadeAnimation,
                      slideAnimation: _slideAnimation,
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      rememberMe: _rememberMe,
                      obscurePassword: _obscurePassword,
                      onRememberMeChanged: (value) {
                        setState(() => _rememberMe = value);
                      },
                      onPasswordVisibilityChanged: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      onLoginPressed: _handleLogin,
                      onGoogleLoginPressed: _handleGoogleLogin,
                      onAppleLoginPressed: _handleAppleLogin,
                    ),
                    if (!isSmallScreen) Gap(20.h),
                    SignupPrompt(
                      onSignupPressed: () {
                         context.pushNamed(Routes.signUpScreen);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}