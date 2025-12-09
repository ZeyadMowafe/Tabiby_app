import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/features/login/data/repo/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;

  LoginCubit(LoginRepository repository)
      : _repository = repository,
        super(const LoginInitial());

  // ==================== Sign In ====================

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      emit(const LoginLoading(isSignIn: true));

      _logInfo('Attempting sign in for: $email');

      final response = await _repository.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.user == null) {
        await _emitErrorAndReset('البريد الإلكتروني أو كلمة المرور غير صحيحة');
        return;
      }

   
      if (response.user!.emailConfirmedAt == null) {
        _logError('Sign in blocked', 'Email not confirmed');
        emit(LoginError(
          'يجب تأكيد البريد الإلكتروني أولاً. تحقق من بريدك الإلكتروني.',
        ));
        await Future.delayed(const Duration(seconds: 3));
        emit(const LoginLoggedOut());
        return;
      }

      _logSuccess('Sign in successful');
      await _loadUserProfile(response.user!);
    } catch (e) {
      _handleSignInError(e, email);
    }
  }

  void _handleSignInError(dynamic error, String email) {
    final errorMessage = error.toString();
    _logError('Sign in error', errorMessage);

   
    if (errorMessage.contains('Email not confirmed')) {
      emit(LoginError(
        'يجب تأكيد البريد الإلكتروني أولاً. تحقق من بريدك الإلكتروني.',
      ));
    } else if (errorMessage.contains('Invalid login credentials')) {
      emit(LoginError('البريد الإلكتروني أو كلمة المرور غير صحيحة'));
    } else {
      emit(LoginError(_parseErrorMessage(errorMessage)));
    }

    // Reset after delay
    Future.delayed(const Duration(seconds: 2), () {
      emit(const LoginLoggedOut());
    });
  }

  // ==================== Social Sign In ====================

  Future<void> signInWithGoogle() async {
    await _handleSocialSignIn(
      () => _repository.signInWithGoogle(),
      'تم إلغاء تسجيل الدخول بـ Google أو فشل',
      isGoogleSignIn: true,
    );
  }

  Future<void> signInWithApple() async {
    await _handleSocialSignIn(
      () => _repository.signInWithApple(),
      'تم إلغاء تسجيل الدخول بـ Apple أو فشل',
      isAppleSignIn: true,
    );
  }

  Future<void> _handleSocialSignIn(
    Future<bool> Function() signInMethod,
    String errorMessage, {
    bool isGoogleSignIn = false,
    bool isAppleSignIn = false,
  }) async {
    try {
      emit(LoginLoading(
        isGoogleSignIn: isGoogleSignIn,
        isAppleSignIn: isAppleSignIn,
      ));

      final success = await signInMethod();

      if (!success) {
        await _emitErrorAndReset(errorMessage);
      } else {
        _logSuccess('Social sign in successful');
      }
    } catch (e) {
      _logError('Social sign in error', e);
      await _emitErrorAndReset(_parseErrorMessage(e.toString()));
    }
  }

  // ==================== Password Reset ====================

  Future<void> sendPasswordResetOTP(String email, String newPassword) async {
    try {
      emit(const LoginLoading(isSendingOTP: true));
      await _repository.sendPasswordResetOTP(email);

      emit(LoginPasswordResetOTPRequired(
        OTPType.passwordReset,
        email: email,
        message: 'أدخل رمز التحقق لإعادة تعيين كلمة المرور',
        newPassword: newPassword,
      ));
    } catch (e) {
      await _emitErrorAndReset(_parseErrorMessage(e.toString()));
    }
  }

  Future<void> verifyOTPAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      emit(const LoginLoading(isOTPVerification: true));

      await _repository.verifyOTPAndResetPassword(
        email: email,
        token: otp,
        newPassword: newPassword,
      );

      await _autoSignInAfterPasswordReset(email, newPassword);
    } catch (e) {
      await _handlePasswordResetError(e, email, newPassword);
    }
  }

  Future<void> _autoSignInAfterPasswordReset(
    String email,
    String newPassword,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final response = await _repository.signIn(
        email: email,
        password: newPassword,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!);
      } else {
        emit(const LoginPasswordResetSuccess());
      }
    } catch (e) {
      emit(const LoginPasswordResetSuccess());
    }
  }

  Future<void> _handlePasswordResetError(
    dynamic error,
    String email,
    String newPassword,
  ) async {
    _logError('Password reset error', error);

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final response = await _repository.signIn(
        email: email,
        password: newPassword,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!);
        return;
      }
    } catch (autoSignInError) {
      _logError('Auto sign-in failed', autoSignInError);
    }

    emit(LoginError(_parseErrorMessage(error.toString())));
    await Future.delayed(const Duration(seconds: 2));

    emit(LoginPasswordResetOTPRequired(
      OTPType.passwordReset,
      email: email,
      message: 'رمز غير صحيح. حاول مرة أخرى',
      newPassword: newPassword,
    ));
  }

  Future<void> resendPasswordResetOTP(String email, String newPassword) async {
    try {
      emit(const LoginLoading(isSendingOTP: true));
      await _repository.sendPasswordResetOTP(email);

      emit(LoginPasswordResetOTPSent(
        email: email,
        message: 'تم إرسال رمز التحقق بنجاح!',
      ));

      await Future.delayed(const Duration(seconds: 2));

      emit(LoginPasswordResetOTPRequired(
        OTPType.passwordReset,
        email: email,
        message: 'أدخل رمز التحقق الجديد المرسل إلى بريدك',
        newPassword: newPassword,
      ));
    } catch (e) {
      emit(LoginError(_parseErrorMessage(e.toString())));
      await Future.delayed(const Duration(seconds: 2));

      emit(LoginPasswordResetOTPRequired(
        OTPType.passwordReset,
        email: email,
        message: 'فشل إعادة إرسال الرمز. حاول مرة أخرى',
        newPassword: newPassword,
      ));
    }
  }

  // ==================== Sign Out ====================

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      emit(const LoginLoggedOut());
    } catch (e) {
      emit(LoginError(_parseErrorMessage(e.toString())));
      await Future.delayed(const Duration(seconds: 2));

      if (state is LoginSuccess) {
        emit(state);
      }
    }
  }

  // ==================== Helper Methods ====================

  Future<void> _loadUserProfile(User user) async {
    try {
      final profile = await _repository.getUserProfile(user.id);
      emit(LoginSuccess(user: user, profile: profile));
    } catch (e) {
      emit(LoginSuccess(user: user));
    }
  }

  Future<void> _emitErrorAndReset(String errorMessage) async {
    emit(LoginError(errorMessage));
    await Future.delayed(const Duration(seconds: 2));
    emit(const LoginLoggedOut());
  }

  void resetToLoggedOut() {
    emit(const LoginLoggedOut());
  }

  // ==================== Logging ====================

  void _logInfo(String message) {
    print('🔐 [Login] $message');
  }

  void _logSuccess(String message) {
    print('✅ [Login] $message');
  }

  void _logError(String message, dynamic error) {
    print('❌ [Login] $message: $error');
  }

  // ==================== Error Parsing ====================

  String _parseErrorMessage(String error) {
    final errorMap = {
      'Invalid login credentials': 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
      'Email not confirmed': 'يرجى تأكيد بريدك الإلكتروني أولاً',
      'weak_password': 'كلمة المرور ضعيفة جداً',
      'email_address_invalid': 'يرجى إدخال بريد إلكتروني صحيح',
      'too_many_requests': 'محاولات كثيرة. حاول لاحقاً',
      'invalid_otp': 'رمز التحقق غير صحيح أو منتهي',
      'token_expired': 'رمز التحقق منتهي الصلاحية',
      'User not found': 'هذا الحساب غير موجود',
    };

    for (final entry in errorMap.entries) {
      if (error.contains(entry.key)) {
        return entry.value;
      }
    }

    return 'حدث خطأ. حاول مرة أخرى';
  }
}