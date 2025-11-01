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
  // ==================== Constants ====================
  
  static const int _otpLength = 6;
  static const int _resendCountdownSeconds = 60;
  static const Duration _animationDuration = Duration(milliseconds: 800);
  
  // ==================== Controllers & Focus ====================
  
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  
  // ==================== Animation ====================
  
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  // ==================== State ====================
  
  Timer? _resendTimer;
  int _resendCountdown = _resendCountdownSeconds;
  bool _canResend = false;

  // ==================== Lifecycle ====================

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _startResendTimer();
    _setSystemUIOverlayStyle();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeAnimations();
    _resendTimer?.cancel();
    super.dispose();
  }

  // ==================== Initialization ====================

  void _initControllers() {
    _controllers = List.generate(
      _otpLength,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: _animationDuration,
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

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _disposeControllers() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
  }

  void _disposeAnimations() {
    _fadeController.dispose();
    _slideController.dispose();
  }

  // ==================== Timer Management ====================

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = _resendCountdownSeconds;
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // ==================== OTP Input Handling ====================

  void _handleOTPInput(String value, int index) {
    if (value.isEmpty) return;

    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
      _verifyOTP();
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

  void _clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  // ==================== OTP Verification ====================

  void _verifyOTP() {
    final otpCode = _getOTPCode();
    
    if (!_isOTPComplete(otpCode)) {
      _showSnackBar(
        'Please enter the complete 6-digit code',
        isError: true,
      );
      return;
    }

    _performVerification(otpCode);
  }

  bool _isOTPComplete(String otp) {
    return otp.length == _otpLength;
  }

  void _performVerification(String otpCode) {
    final cubit = context.read<AppAuthCubit>();
    
    if (widget.otpType == OTPType.emailVerification) {
      cubit.verifyEmailOTP(email: widget.email, otp: otpCode);
    } else if (widget.otpType == OTPType.passwordReset) {
      if (widget.newPassword != null) {
        cubit.verifyOTPAndResetPassword(
          email: widget.email,
          otp: otpCode,
          newPassword: widget.newPassword!,
        );
      }
    }
  }

  // ==================== Resend OTP ====================

  void _resendOTP() {
    if (!_canResend) return;

    context.read<AppAuthCubit>().resendOTP(widget.email, widget.otpType);
    _startResendTimer();
  }

  // ==================== Navigation ====================

  void _goBack() {
    Navigator.pop(context);
  }

  // ==================== Snackbar ====================

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? AppColors.errorRed : AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ==================== Build Methods ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBlue,
      body: SafeArea(
        child: BlocListener<AppAuthCubit, AppAuthState>(
          listener: _handleAuthStateChanges,
          child: _buildOTPContent(),
        ),
      ),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AppAuthState state) {
    if (state is AppAuthError) {
      _showSnackBar(state.message, isError: true);
      _clearOTP();
    } else if (state is AppAuthAuthenticated) {
      _handleSuccessfulAuthentication();
    } else if (state is AppAuthPasswordResetSuccess) {
      _handlePasswordResetSuccess();
    } else if (state is AppAuthOTPSent) {
      _showSnackBar('New verification code sent!');
    }
  }

  void _handleSuccessfulAuthentication() {
    final message = widget.otpType == OTPType.emailVerification
        ? 'Email verified successfully!'
        : 'Password reset completed! Welcome back.';

    _showSnackBar(message);
    
    Future.delayed(const Duration(seconds: 1), () {
      context.pushNamedAndRemoveUntil(
        Routes.homeScreen,
        predicate: (_) => false,
      );
    });
  }

  void _handlePasswordResetSuccess() {
    _showSnackBar('Password reset completed successfully!');
    
    Future.delayed(const Duration(seconds: 1), () {
      context.pushNamedAndRemoveUntil(
        Routes.homeScreen,
        predicate: (_) => false,
      );
    });
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
                  _buildBackButton(),
                  SizedBox(height: isSmallScreen ? 20 : 40),
                  _buildHeader(isTablet, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 40 : 60),
                  _buildForm(isTablet),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        IconButton(
          onPressed: _goBack,
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildHeader(bool isTablet, bool isSmallScreen) {
    return FadeTransition(
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
    );
  }

  Widget _buildForm(bool isTablet) {
    return FadeTransition(
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
        final isLoading = _isLoadingState(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 40),
            _buildOTPInputFields(),
            const SizedBox(height: 32),
            _buildVerifyButton(isLoading),
            const SizedBox(height: 24),
            _buildResendSection(isLoading),
            const SizedBox(height: 32),
            _buildHelpText(),
          ],
        );
      },
    );
  }

  bool _isLoadingState(AppAuthState state) {
    return state is AppAuthLoading &&
        (state.isOTPVerification || state.isSendingOTP);
  }

  Widget _buildInfoCard() {
    return Container(
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
            _getInfoIcon(),
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
          _buildEmailBadge(),
        ],
      ),
    );
  }

  IconData _getInfoIcon() {
    return widget.otpType == OTPType.emailVerification
        ? Icons.mark_email_read_outlined
        : Icons.security_outlined;
  }

  Widget _buildEmailBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }

  Widget _buildOTPInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_otpLength, (index) => _buildOTPField(index)),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: _buildOTPFieldDecoration(index),
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
        onTap: () => _handleFieldTap(index),
      ),
    );
  }

  BoxDecoration _buildOTPFieldDecoration(int index) {
    final isEmpty = _controllers[index].text.isEmpty;
    
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isEmpty
            ? Colors.grey.withOpacity(0.3)
            : AppColors.primaryBlue,
        width: isEmpty ? 1 : 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _handleFieldTap(int index) {
    if (_controllers[index].text.isNotEmpty) {
      _controllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _controllers[index].text.length),
      );
    }
  }

  Widget _buildVerifyButton(bool isLoading) {
    return CustomButton(
      text: _getVerifyButtonText(),
      onPressed: isLoading ? null : _verifyOTP,
      isLoading: isLoading,
      width: double.infinity,
    );
  }

  String _getVerifyButtonText() {
    return widget.otpType == OTPType.emailVerification
        ? 'Verify Email'
        : 'Complete Reset';
  }

  Widget _buildResendSection(bool isLoading) {
    return Center(
      child: _canResend
          ? _buildResendButton(isLoading)
          : _buildCountdownText(),
    );
  }

  Widget _buildResendButton(bool isLoading) {
    return TextButton.icon(
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
    );
  }

  Widget _buildCountdownText() {
    return Text(
      'Resend code in ${_resendCountdown}s',
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildHelpText() {
    return Container(
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
    );
  }
}