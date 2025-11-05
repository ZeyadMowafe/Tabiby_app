import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/helpers/extentions.dart';

import 'package:tabiby/features/auth/ui/widgets/auth_header.dart';
import 'package:tabiby/features/auth/ui/widgets/custom_text_field.dart';
import 'package:tabiby/features/auth/ui/widgets/social_login_buttom.dart';

import '../../../core/helpers/valifators.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'email_verification_screen.dart';
import 'OTP_screen.dart'; // إضافة استيراد شاشة OTP
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptTerms = false;
  bool _subscribeNewsletter = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
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
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning_outlined, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please accept terms and conditions to continue',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      context.read<AppAuthCubit>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );
    }
  }

  void _handleGoogleSignUp() {
    context.read<AppAuthCubit>().signInWithGoogle();
  }

  void _handleAppleSignUp() {
    context.read<AppAuthCubit>().signInWithApple();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 10) {
        return 'Please enter a valid phone number';
      }
      if (!RegExp(r'^[\+]?[0-9]{10,15}$').hasMatch(value)) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
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
                      const SizedBox(width: 8),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            } else if (state is AppAuthAuthenticated) {
              // المستخدم مسجل ومتحقق من الإيميل - انتقل للهوم
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Account created successfully! Welcome to Tabiby.',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );

              // الانتقال للصفحة الرئيسية
              Future.delayed(const Duration(seconds: 1), () {
                context.pushNamedAndRemoveUntil(
                  Routes.homeScreen, 
                  predicate: (route) => false,
                );
              });
            } else if (state is AppAuthOTPRequired) {
              // الحالة الجديدة: مطلوب OTP للتحقق من الإيميل
              if (state.otpType == OTPType.emailVerification) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<AppAuthCubit>(),
                      child: OTPInputScreen(
                        email: state.email,
                        otpType: OTPType.emailVerification,
                        message: state.message,
                      ),
                    ),
                  ),
                );
              }
            } else if (state is AppAuthEmailSent) {
              // الحالة القديمة للتوافق (إذا كان لا يزال يستخدم)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailVerificationScreen(
                    email: state.email,
                    message: state.message,
                  ),
                ),
              );
            } else if (state is AppAuthEmailNotVerified) {
              // إذا كان المستخدم مسجل لكن الإيميل غير متحقق
              // يمكن استخدام OTP أو الطريقة القديمة حسب التفضيل
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AppAuthCubit>(),
                    child: OTPInputScreen(
                      email: state.email,
                      otpType: OTPType.emailVerification,
                      message: state.message,
                    ),
                  ),
                ),
              );
            }
          },
          child: _buildSignUpContent(),
        ),
      ),
    );
  }

  Widget _buildSignUpContent() {
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
                horizontal: isTablet ? 48.0 : 24.0,
                vertical: isSmallScreen ? 16.0 : 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AuthHeader(
                        title: 'Create Account',
                        subtitle: 'Join Tabiby today and start your health journey',
                        isTablet: isTablet,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 32 : 48),

                  // Sign Up Form
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400 : double.infinity,
                        ),
                        child: _buildSignUpForm(),
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

  Widget _buildSignUpForm() {
    return BlocBuilder<AppAuthCubit, AppAuthState>(
      builder: (context, state) {
        final isLoading = state is AppAuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We\'ll send you a verification code via email to confirm your account.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Full Name Field
              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
                validator: _validateFullName,
                enabled: !isLoading,
              ),

              const SizedBox(height: 20),

              // Email Field
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                enabled: !isLoading,
              ),

              const SizedBox(height: 20),

              // Phone Number Field (Optional)
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number (Optional)',
                hintText: 'Enter your phone number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: _validatePhoneNumber,
                enabled: !isLoading,
              ),

              const SizedBox(height: 20),

              // Password Field
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Create a password',
                prefixIcon: Icons.lock_outlined,
                isPassword: true,
                validator: Validators.validatePassword,
                enabled: !isLoading,
                onChanged: (value) {
                  if (_confirmPasswordController.text.isNotEmpty) {
                    _formKey.currentState?.validate();
                  }
                },
              ),

              const SizedBox(height: 20),

              // Confirm Password Field
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                validator: _validateConfirmPassword,
                enabled: !isLoading,
              ),

              const SizedBox(height: 20),

              // Password Requirements
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Requirements:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildRequirement('At least 8 characters'),
                    _buildRequirement('Uppercase & lowercase letters'),
                    _buildRequirement('At least one number'),
                    _buildRequirement('At least one special character'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Terms and Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: isLoading
                          ? null
                          : (value) {
                        setState(() => _acceptTerms = value ?? false);
                      },
                      activeColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Newsletter Subscription (Optional)
              Row(
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: _subscribeNewsletter,
                      onChanged: isLoading
                          ? null
                          : (value) {
                        setState(() => _subscribeNewsletter = value ?? false);
                      },
                      activeColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Subscribe to health tips and updates',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Sign Up Button
              CustomButton(
                text: 'Create Account',
                onPressed: isLoading ? null : _handleSignUp,
                isLoading: isLoading &&
                    state is AppAuthLoading &&
                    (state as AppAuthLoading).isSignUp,
                width: double.infinity,
              ),

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                        color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or sign up with',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                        color: AppColors.textSecondary.withOpacity(0.3)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Social Sign Up Buttons
              Row(
                children: [
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: 'Google',
                      onTap: _handleGoogleSignUp,
                      isLoading: isLoading &&
                          state is AppAuthLoading &&
                          (state as AppAuthLoading).isGoogleSignIn,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SocialLoginButton(
                      icon: Icons.apple_rounded,
                      label: 'Apple',
                      onTap: _handleAppleSignUp,
                      isLoading: isLoading &&
                          state is AppAuthLoading &&
                          (state as AppAuthLoading).isAppleSignIn,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRequirement(String requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 12,
            color: AppColors.textSecondary.withOpacity(0.6),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}