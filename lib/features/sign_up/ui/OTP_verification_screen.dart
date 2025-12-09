// features/sign_up/ui/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/helper/extentation.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_cubit.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_state.dart';
import 'dart:async';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(6, (_) => FocusNode());

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setStatusBar();
    _startResendTimer();
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
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
      }
    });
  }

  void _handleOTPInput(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOTP();
      }
    }
  }

  void _verifyOTP() {
    final otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length == 6) {
      FocusScope.of(context).unfocus();
      context.read<SignupCubit>().verifyEmailOTP(
        email: widget.email,
        otp: otp,
      );
    } else {
      _showSnackbar(
        message: 'يرجى إدخال رمز التحقق كاملاً',
        icon: Icons.warning_rounded,
        color: Colors.orange,
      );
    }
  }

  void _resendOTP() {
    if (_canResend) {
      context.read<SignupCubit>().resendVerificationEmail(widget.email);
      _startResendTimer();
    }
  }

  void _clearOTP() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E40AF),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<SignupCubit, SignupState>(
            listener: _handleStateChanges,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, SignupState state) {
    if (state is SignupError) {
      _showSnackbar(
        message: state.message,
        icon: Icons.error_rounded,
        color: Colors.red,
      );
      _clearOTP();
    } else if (state is SignupOTPSent) {
      _showSnackbar(
        message: state.message,
        icon: Icons.check_circle_rounded,
        color: Colors.green,
      );
    } else if (state is SignupSuccess) {
      _showSnackbar(
        message: 'تم تأكيد الحساب بنجاح! 🎉',
        icon: Icons.celebration_rounded,
        color: Colors.green,
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.pushReplacementNamed(Routes.homeScreen);
        }
      });
    }
  }

  void _showSnackbar({
    required String message,
    required IconData icon,
    required Color color,
  }) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22.sp),
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
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 700;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackButton(),
                  Column(
                    children: [
                      if (!isSmallScreen) Gap(40.h),
                      _buildHeader(),
                      Gap(isSmallScreen ? 40.h : 60.h),
                      _buildOTPCard(),
                    ],
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.email_outlined,
              size: 60.sp,
              color: Colors.white,
            ),
          ),
          Gap(24.h),
          Text(
            'تأكيد البريد الإلكتروني',
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(12.h),
          Text(
            'أدخل الرمز المرسل إلى',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              widget.email,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildOTPFields(),
              Gap(32.h),
              _buildVerifyButton(),
              Gap(24.h),
              _buildResendSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPFields() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 30.w,
            height: 40.h,
            child: TextField(
              controller: _otpControllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E40AF),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: const Color(0xFF3B82F6),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                _handleOTPInput(value, index);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final isLoading = state is SignupLoading && state.isOTPVerification;

        return SizedBox(
          width: double.infinity,
          height: 54.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFCBD5E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'تأكيد الحساب',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildResendSection() {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final isResending = state is SignupLoading && state.isEmailResend;

        return Column(
          children: [
            Text(
              'لم تستلم الرمز؟',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(8.h),
            if (isResending)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16.h,
                    width: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Text(
                    'جاري الإرسال...',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else if (_canResend)
              TextButton(
                onPressed: _resendOTP,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'إعادة إرسال الرمز',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF3B82F6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Text(
                'يمكنك إعادة الإرسال بعد $_resendCountdown ثانية',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        );
      },
    );
  }
}