// features/sign_up/ui/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/helper/extentation.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_cubit.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_state.dart';
import 'package:tabiby/features/sign_up/ui/widgets/wid.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

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

  void _handleSignUp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        _showSnackbar(
          context,
          message: 'يرجى الموافقة على الشروط والأحكام',
          icon: Icons.warning_rounded,
          color: const Color(0xFFEA580C),
        );
        return;
      }

      context.read<SignupCubit>().signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: BlocListener<SignupCubit, SignupState>(
          listener: _handleStateChanges,
          child: _buildBody(),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, SignupState state) {
    if (state is SignupError) {
      _showSnackbar(
        context,
        message: state.message,
        icon: Icons.error_rounded,
        color: const Color(0xFFDC2626),
      );
    } else if (state is SignupOTPRequired) {
      _showSnackbar(
        context,
        message: state.message,
        icon: Icons.email_outlined,
        color: const Color(0xFF1E40AF),
      );
      // Navigate to OTP verification screen
      _navigateToOTPScreen(state.email);
    } else if (state is SignupOTPSent) {
      _showSnackbar(
        context,
        message: state.message,
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF059669),
      );
    } else if (state is SignupSuccess) {
      _showSnackbar(
        context,
        message: 'تم إنشاء الحساب بنجاح',
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF059669),
      );
      Future.delayed(const Duration(milliseconds: 1000), () {
        context.pushReplacementNamed(Routes.homeScreen);
      });
    }
  }

 void _navigateToOTPScreen(String email) {
  context.pushNamed(
    Routes.otpScreen,
    arguments: email,
  );
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
                    SignupHeader(
                      fadeAnimation: _fadeAnimation,
                    ),
                    Gap(isSmallScreen ? 32.h : 48.h),
                    SignupFormCard(
                      fadeAnimation: _fadeAnimation,
                      slideAnimation: _slideAnimation,
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      acceptTerms: _acceptTerms,
                      obscurePassword: _obscurePassword,
                      obscureConfirmPassword: _obscureConfirmPassword,
                      onAcceptTermsChanged: (value) {
                        setState(() => _acceptTerms = value);
                      },
                      onPasswordVisibilityChanged: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      onConfirmPasswordVisibilityChanged: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                      onSignUpPressed: _handleSignUp,
                    ),
                    if (!isSmallScreen) Gap(20.h),
                    LoginPrompt(
                      onLoginPressed: () {
                        context.pop();
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