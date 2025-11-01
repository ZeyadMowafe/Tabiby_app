import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/helpers/extentions.dart';

import 'package:tabiby/features/login/ui/sign_up_screen.dart';
import 'package:tabiby/features/login/ui/widgets/auth_header.dart';
import 'package:tabiby/features/login/ui/widgets/custom_text_field.dart';
import 'package:tabiby/features/login/ui/widgets/divider_with_text.dart';
import 'package:tabiby/features/login/ui/widgets/remember_me_row.dart';
import 'package:tabiby/features/login/ui/widgets/sign_up_prompt.dart';
import 'package:tabiby/features/login/ui/widgets/social_login_row.dart';

import '../../../core/helpers/valifators.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'forget_password_screen.dart';

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

  late AnimationController _contentController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _initAnimations() {
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _contentController.forward();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AppAuthCubit>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            rememberMe: _rememberMe,
          );
    }
  }

  void _handleGoogleLogin() {
    context.read<AppAuthCubit>().signInWithGoogle();
  }

  void _handleAppleLogin() {
    context.read<AppAuthCubit>().signInWithApple();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBlue,
      body: SafeArea(
        child: BlocListener<AppAuthCubit, AppAuthState>(
          listener: (context, state) {
            if (state is AppAuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          state.message,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.errorRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  margin: EdgeInsets.all(16.w),
                ),
              );
            } else if (state is AppAuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      Gap(8.w),
                      const Text(
                        'Login Successful!',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  margin: EdgeInsets.all(16.w),
                ),
              );

              context.pushReplacementNamed(Routes.homeScreen);
            }
          },
          child: _buildLoginContent(),
        ),
      ),
    );
  }

  Widget _buildLoginContent() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 768;
    final isSmallScreen = screenSize.height < 700;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 48.w : 24.w,
                vertical: isSmallScreen ? 2.h : 2.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AuthHeader(
                        title: 'Welcome Back',
                        subtitle: 'Sign in to Tabiby',
                        isTablet: isTablet,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ),
                  Gap(isSmallScreen ? 40.h : 60.h),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400.w : double.infinity,
                        ),
                        child: _buildLoginForm(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return BlocBuilder<AppAuthCubit, AppAuthState>(
      builder: (context, state) {
        final isLoading = state is AppAuthLoading;

        return Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  enabled: !isLoading,
                ),
                Gap(20.h),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outlined,
                  isPassword: true,
                  validator: Validators.validatePassword,
                  enabled: !isLoading,
                ),
                Gap(16.h),
                RememberMeRow(
                  rememberMe: _rememberMe,
                  isLoading: isLoading,
                  onRememberMeChanged: (value) {
                    setState(() => _rememberMe = value);
                  },
                  onForgotPasswordTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                ),
                 SignUpPrompt(
                  isLoading: isLoading,
                  onSignUpTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
                Gap(10.h),
                CustomButton(
                  text: 'Sign In',
                  onPressed: isLoading ? null : _handleLogin,
                  isLoading: isLoading &&
                      state is AppAuthLoading &&
                      (state as AppAuthLoading).isSignIn,
                  width: double.infinity,
                ),
                Gap(24.h),
                const DividerWithText(text: 'Or continue with'),
                Gap(24.h),
                SocialLoginRow(
                  onGoogleTap: _handleGoogleLogin,
                  onAppleTap: _handleAppleLogin,
                  isGoogleLoading: isLoading &&
                      state is AppAuthLoading &&
                      (state as AppAuthLoading).isGoogleSignIn,
                  isAppleLoading: isLoading &&
                      state is AppAuthLoading &&
                      (state as AppAuthLoading).isAppleSignIn,
                ),
                Gap(10.h),
               
              ],
            ),
          ),
        );
      },
    );
  }
}

// Stateless Widgets






