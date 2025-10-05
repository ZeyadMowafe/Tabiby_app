import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/helpers/extentions.dart';
import 'dart:async';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_buttom.dart';
import '../../../core/routing/routes.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';
import 'widgets/auth_header.dart';

class OTPInputScreen extends StatefulWidget {
  final String email;
  final OTPType otpType;
  final String? message;
  final String? newPassword; 

  const OTPInputScreen({
    Key? key,
    required this.email,
    required this.otpType,
    this.message,
    this.newPassword,
  }) : super(key: key);

  @override
  State<OTPInputScreen> createState() => _OTPInputScreenState();
}

class _OTPInputScreenState extends State<OTPInputScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startResendTimer();

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleOTPInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOTP();
      }
    }
  }

  void _handleBackspace(String value, int index) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOTPCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _verifyOTP() {
    final otpCode = _getOTPCode();
    if (otpCode.length == 6) {
      if (widget.otpType == OTPType.emailVerification) {
        context.read<AppAuthCubit>().verifyEmailOTP(
          email: widget.email,
          otp: otpCode,
        );
      } else if (widget.otpType == OTPType.passwordReset) {
        if (widget.newPassword != null) {
          context.read<AppAuthCubit>().verifyOTPAndResetPassword(
            email: widget.email,
            otp: otpCode,
            newPassword: widget.newPassword!,
          );
        }
      }
    } else {
      _showErrorSnackBar('Please enter the complete 6-digit code');
    }
  }

  void _resendOTP() {
    if (_canResend) {
      context.read<AppAuthCubit>().resendOTP(widget.email, widget.otpType);
      _startResendTimer();
    }
  }

  void _clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _goBack() {
    Navigator.pop(context);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _fadeController.dispose();
    _slideController.dispose();
    _resendTimer?.cancel();
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
              _clearOTP(); // مسح الكود عند حدوث خطأ
            } else if (state is AppAuthAuthenticated) {
              if (widget.otpType == OTPType.emailVerification) {
                // تم التحقق من الإيميل بنجاح - الانتقال للصفحة الرئيسية
                _showSuccessSnackBar('Email verified successfully!');
                Future.delayed(const Duration(seconds: 1), () {
                  context.pushNamedAndRemoveUntil(
                    Routes.homeScreen,
                    predicate: (_) => false,
                  );
                });
              } else if (widget.otpType == OTPType.passwordReset) {
                // تم إعادة تعيين كلمة المرور بنجاح - الانتقال للهوم مباشرة
                _showSuccessSnackBar('Password reset completed! Welcome back.');
                Future.delayed(const Duration(seconds: 1), () {
                  context.pushNamedAndRemoveUntil(
                    Routes.homeScreen,
                    predicate: (route) => false,
                  );
                });
              }
            } else if (state is AppAuthPasswordResetSuccess) {
              // هذه الحالة للتوافق مع الكود القديم
              // لكن في التدفق الجديد، يجب أن يصبح المستخدم مسجل دخول تلقائياً
              _showSuccessSnackBar('Password reset completed successfully!');
              Future.delayed(const Duration(seconds: 1), () {
                context.pushNamedAndRemoveUntil(
                  Routes.homeScreen,
                  predicate: (route) => false,
                );
              });
            } else if (state is AppAuthOTPSent) {
              // تم إعادة إرسال الكود
              _showSuccessSnackBar('New verification code sent!');
            }
          },
          child: _buildOTPContent(),
        ),
      ),
    );
  }

  Widget _buildOTPContent() {
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
                  // Back Button
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
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 40),

                  // Header Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AuthHeader(
                        title: _getTitle(),
                        subtitle: _getSubtitle(),
                        isTablet: isTablet,
                        isSmallScreen: isSmallScreen,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 40 : 60),

                  // OTP Input Form
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400 : double.infinity,
                        ),
                        child: _buildOTPForm(),
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

  String _getTitle() {
    return widget.otpType == OTPType.emailVerification
        ? 'Verify Your Email'
        : 'Complete Password Reset';
  }

  String _getSubtitle() {
    return widget.otpType == OTPType.emailVerification
        ? 'Enter the verification code sent to your email'
        : 'Enter the verification code to complete password reset';
  }

  Widget _buildOTPForm() {
    return BlocBuilder<AppAuthCubit, AppAuthState>(
      builder: (context, state) {
        final isLoading =
            state is AppAuthLoading &&
            (state.isOTPVerification || state.isSendingOTP);

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
                    widget.otpType == OTPType.emailVerification
                        ? Icons.mark_email_read_outlined
                        : Icons.security_outlined,
                    size: 48,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'ve sent a 6-digit verification code to:',
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
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOTPField(index)),
            ),

            const SizedBox(height: 32),

            // Verify Button
            CustomButton(
              text:
                  widget.otpType == OTPType.emailVerification
                      ? 'Verify Email'
                      : 'Complete Reset',
              onPressed: isLoading ? null : _verifyOTP,
              isLoading: isLoading,
              width: double.infinity,
            ),

            const SizedBox(height: 24),

            // Resend Code
            Center(
              child:
                  _canResend
                      ? TextButton.icon(
                        onPressed: isLoading ? null : _resendOTP,
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                        label: Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      : Text(
                        'Resend code in ${_resendCountdown}s',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
            ),

            const SizedBox(height: 32),

            // Help Text
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
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Didn\'t receive the code?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Check your spam folder or wait for the resend option',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _controllers[index].text.isEmpty
                  ? Colors.grey.withOpacity(0.3)
                  : AppColors.primaryBlue,
          width: _controllers[index].text.isEmpty ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _handleOTPInput(value, index),
        onTap: () {
          if (_controllers[index].text.isNotEmpty) {
            _controllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index].text.length),
            );
          }
        },
      ),
    );
  }
}
