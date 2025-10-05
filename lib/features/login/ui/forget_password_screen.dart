import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/helpers/extentions.dart';

import '../../../core/helpers/valifators.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/routing/routes.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'widgets/auth_header.dart';
import 'widgets/custom_text_field.dart';
import 'OTP_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentStep = 0; // 0: Email, 1: New Password

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

  void _handleNextStep() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep == 0) {
        // انتقل للخطوة التالية (إدخال كلمة المرور الجديدة)
        setState(() {
          _currentStep = 1;
        });
      } else if (_currentStep == 1) {
        // التحقق من تطابق كلمات المرور
        if (_passwordController.text != _confirmPasswordController.text) {
          _showErrorSnackBar('Passwords do not match');
          return;
        }
        
        // إرسال OTP وانتقل لشاشة التحقق
        context.read<AppAuthCubit>().sendPasswordResetOTP(
          _emailController.text.trim(),
        );
      }
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
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

  @override
  void dispose() {
    _emailController.dispose();
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
              _showErrorSnackBar(state.message);
            } else if (state is AppAuthOTPRequired) {
              if (state.otpType == OTPType.passwordReset) {
                // الانتقال لشاشة إدخال OTP مع كلمة المرور الجديدة
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<AppAuthCubit>(),
                      child: OTPInputScreen(
                        email: _emailController.text.trim(),
                        otpType: OTPType.passwordReset,
                        newPassword: _passwordController.text,
                        message: 'Enter the verification code to complete password reset',
                      ),
                    ),
                  ),
                );
              }
            }
          },
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
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
                  // Back Button and Progress
                  Row(
                    children: [
                      IconButton(
                        onPressed: _goBack,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textPrimary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildProgressIndicator(),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 40),

                  // Header Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AuthHeader(
                        title: _getStepTitle(),
                        subtitle: _getStepSubtitle(),
                        isTablet: isTablet,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 40 : 60),

                  // Form Content
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400 : double.infinity,
                        ),
                        child: _buildStepContent(),
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

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Forgot Password?';
      case 1:
        return 'New Password';
      default:
        return 'Reset Password';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Enter your email to start password reset';
      case 1:
        return 'Choose a strong new password';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index <= _currentStep
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    return BlocBuilder<AppAuthCubit, AppAuthState>(
      builder: (context, state) {
        final isLoading = state is AppAuthLoading;

        return Form(
          key: _formKey,
          child: _currentStep == 0 ? _buildEmailStep(isLoading) : _buildPasswordStep(isLoading),
        );
      },
    );
  }

  Widget _buildEmailStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.lock_reset_outlined,
                size: 48,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 12),
              Text(
                'Don\'t worry, we\'ll help you reset your password. Enter your email address to continue.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Email Field
        CustomTextField(
          controller: _emailController,
          label: 'Email Address',
          hintText: 'Enter your registered email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          enabled: !isLoading,
        ),

        const SizedBox(height: 32),

        // Continue Button
        CustomButton(
          text: 'Continue',
          onPressed: isLoading ? null : _handleNextStep,
          isLoading: isLoading,
          width: double.infinity,
        ),

        const SizedBox(height: 24),

        // Back to Login
        Center(
          child: TextButton.icon(
            onPressed: isLoading ? null : () => context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false),
            icon: Icon(
              Icons.arrow_back,
              size: 18,
              color: AppColors.primaryBlue,
            ),
            label: const Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.successGreen.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.security_outlined,
                size: 48,
                color: AppColors.successGreen,
              ),
              const SizedBox(height: 12),
              Text(
                'Almost there! Choose a strong password for your account.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _emailController.text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.successGreen,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // New Password Field
        CustomTextField(
          controller: _passwordController,
          label: 'New Password',
          hintText: 'Enter new password',
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
          hintText: 'Confirm new password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          validator: _validateConfirmPassword,
          enabled: !isLoading,
        ),

        const SizedBox(height: 32),

        // Password Requirements
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Requirements:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildRequirement('At least 8 characters long'),
              _buildRequirement('Contains uppercase and lowercase letters'),
              _buildRequirement('Contains at least one number'),
              _buildRequirement('Contains at least one special character'),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Continue to Verification Button
        CustomButton(
          text: 'Continue to Verification',
          onPressed: isLoading ? null : _handleNextStep,
          isLoading: isLoading,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildRequirement(String requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColors.textSecondary.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}