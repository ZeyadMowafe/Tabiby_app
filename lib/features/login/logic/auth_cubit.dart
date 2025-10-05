import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/model/user_profile.dart';
import '../data/repo/auth_repo.dart';
import 'auth_state.dart';

class AppAuthCubit extends Cubit<AppAuthState> {
  final AuthRepository _authRepository;

  AppAuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthInitial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authRepository.authStateStream.listen((authState) async {
      if (authState is AppAuthAuthenticated) {
        await _handleUserAuthenticated(authState.user);
      } else if (authState is AppAuthUnauthenticated) {
        emit(authState);
      }
    });
  }

  Future<void> _handleUserAuthenticated(User user) async {
    try {
      // تحديث حالة التحقق من الإيميل
      await _authRepository.updateEmailVerificationInProfile(user);
      final profile = await _authRepository.getUserProfile(user.id);
      final isEmailVerified = user.emailConfirmedAt != null;

      if (!isEmailVerified) {
        emit(AppAuthEmailNotVerified(
          user: user,
          profile: profile,
          email: user.email ?? '',
          message: 'Please verify your email address to continue.',
        ));
      } else {
        emit(AppAuthAuthenticated(user: user, profile: profile));
      }
    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(const AppAuthLoading());

    final user = _authRepository.currentUser;
    if (user != null) {
      await _handleUserAuthenticated(user);
    } else {
      emit(const AppAuthUnauthenticated());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      emit(const AppAuthLoading(isSignIn: true));

      final response = await _authRepository.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.user == null) {
        emit(const AppAuthError('Invalid email or password.'));
        await Future.delayed(const Duration(seconds: 2));
        emit(const AppAuthUnauthenticated());
      }
    } catch (e) {
      String errorMessage = _parseError(e.toString());

      if (e.toString().contains('Email not confirmed')) {
        emit(AppAuthEmailNotVerified(
          email: email,
          message: 'Please verify your email address before signing in.',
        ));
        return;
      }

      emit(AppAuthError(errorMessage));
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppAuthUnauthenticated());
    }
  }

  Future<void> signUp({
  required String email,
  required String password,
  String? fullName,
  String? phoneNumber,
}) async {
  try {
    emit(const AppAuthLoading(isSignUp: true));

    final response = await _authRepository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );

    if (response.user != null) {
      if (response.user?.emailConfirmedAt == null) {
        // إرسال حالة طلب OTP للتحقق من الإيميل
        emit(AppAuthOTPRequired(
          email: email,
          otpType: OTPType.emailVerification,
          message: 'Please enter the verification code sent to your email to activate your account.',
        ));
      } else {
        await _loadUserProfile(response.user!);
      }
    } else {
      emit(const AppAuthError('Sign up failed. Please try again.'));
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppAuthUnauthenticated());
    }
  } catch (e) {
    emit(AppAuthError(_parseError(e.toString())));
    await Future.delayed(const Duration(seconds: 2));
    emit(const AppAuthUnauthenticated());
  }
}

  // دالة جديدة لإرسال OTP لإعادة تعيين كلمة المرور
  Future<void> sendPasswordResetOTP(String email) async {
    try {
      emit(const AppAuthLoading(isSendingOTP: true));

      await _authRepository.sendPasswordResetOTP(email);

      emit(AppAuthOTPRequired(
        email: email,
        otpType: OTPType.passwordReset,
        message: 'Please enter the verification code sent to your email to reset your password.',
      ));
    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppAuthUnauthenticated());
    }
  }

  // دالة جديدة للتحقق من OTP وإعادة تعيين كلمة المرور
  Future<void> verifyOTPAndResetPassword({
  required String email,
  required String otp,
  required String newPassword,
}) async {
  try {
    emit(const AppAuthLoading(isOTPVerification: true));

    // التحقق من OTP وإعادة تعيين كلمة المرور
    await _authRepository.verifyOTPAndResetPassword(
      email: email,
      token: otp,
      newPassword: newPassword,
    );

    // تسجيل الدخول التلقائي بكلمة المرور الجديدة
    await Future.delayed(const Duration(milliseconds: 500)); // انتظار قصير للتأكد من تطبيق التغييرات
    
    final response = await _authRepository.signIn(
      email: email,
      password: newPassword,
    );

    if (response.user != null) {
      // تحديث حالة التحقق من الإيميل في الملف الشخصي
      await _authRepository.updateEmailVerificationInProfile(response.user!);
      
      // تحميل الملف الشخصي
      final profile = await _authRepository.getUserProfile(response.user!.id);
      
      // إصدار حالة المستخدم المصادق عليه
      emit(AppAuthAuthenticated(user: response.user!, profile: profile));
    } else {
      // في حالة فشل تسجيل الدخول التلقائي، إرسال حالة نجح إعادة التعيين
      emit(const AppAuthPasswordResetSuccess());
    }

  } catch (e) {
    print('❌ Verify OTP and reset password error: $e');
    
    // في حالة الخطأ، محاولة تسجيل الدخول التلقائي كإجراء بديل
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final response = await _authRepository.signIn(
        email: email,
        password: newPassword,
      );
      
      if (response.user != null) {
        await _authRepository.updateEmailVerificationInProfile(response.user!);
        final profile = await _authRepository.getUserProfile(response.user!.id);
        emit(AppAuthAuthenticated(user: response.user!, profile: profile));
        return;
      }
    } catch (autoSignInError) {
      print('❌ Auto sign-in after password reset failed: $autoSignInError');
    }
    
    emit(AppAuthError(_parseError(e.toString())));
    await Future.delayed(const Duration(seconds: 2));
    
    // العودة لحالة طلب OTP
    emit(AppAuthOTPRequired(
      email: email,
      otpType: OTPType.passwordReset,
      message: 'Invalid code. Please try again.',
    ));
  }
}
  // دالة جديدة للتحقق من OTP للإيميل
  Future<void> verifyEmailOTP({
    required String email,
    required String otp,
  }) async {
    try {
      emit(const AppAuthLoading(isOTPVerification: true));

      final response = await _authRepository.verifyEmailOTP(
        email: email,
        token: otp,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!);
      } else {
        throw Exception('Email verification failed');
      }

    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      
      // العودة لحالة طلب OTP
      emit(AppAuthOTPRequired(
        email: email,
        otpType: OTPType.emailVerification,
        message: 'Invalid code. Please try again.',
      ));
    }
  }

  // دالة لإعادة إرسال OTP
  Future<void> resendOTP(String email, OTPType otpType) async {
    try {
      emit(const AppAuthLoading(isSendingOTP: true));

      if (otpType == OTPType.emailVerification) {
        await _authRepository.sendEmailVerificationOTP(email);
      } else if (otpType == OTPType.passwordReset) {
        await _authRepository.sendPasswordResetOTP(email);
      }

      emit(AppAuthOTPSent(
        email: email,
        message: 'Verification code sent successfully!',
        otpType: otpType,
      ));

      // العودة لحالة طلب OTP
      await Future.delayed(const Duration(seconds: 2));
      emit(AppAuthOTPRequired(
        email: email,
        otpType: otpType,
        message: 'Please enter the new verification code sent to your email.',
      ));

    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));

      // العودة لحالة طلب OTP
      emit(AppAuthOTPRequired(
        email: email,
        otpType: otpType,
        message: 'Failed to resend code. Please try again.',
      ));
    }
  }

  Future<void> _loadUserProfile(User user) async {
    try {
      final profile = await _authRepository.getUserProfile(user.id);
      emit(AppAuthAuthenticated(user: user, profile: profile));
    } catch (e) {
      emit(AppAuthAuthenticated(user: user));
    }
  }

  // الاحتفاظ بالدالة القديمة للتوافق مع الكود الموجود
  @Deprecated('Use sendPasswordResetOTP instead')
  Future<void> resetPassword(String email) async {
    await sendPasswordResetOTP(email);
  }

  // الاحتفاظ بالدالة القديمة للتوافق مع الكود الموجود
  @Deprecated('Use verifyOTPAndResetPassword instead')
  Future<void> updatePassword(String newPassword) async {
    try {
      emit(const AppAuthLoading(isPasswordUpdate: true));

      await _authRepository.updatePassword(newPassword);

      emit(const AppAuthPasswordResetSuccess());

      await Future.delayed(const Duration(seconds: 2));
      await signOut();

    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppAuthUnauthenticated());
    }
  }

  // دالة محدثة لإعادة إرسال رمز التحقق
  Future<void> resendVerificationEmail(String email) async {
    try {
      emit(const AppAuthLoading(isEmailResend: true));

      await _authRepository.sendEmailVerificationOTP(email);

      emit(AppAuthOTPSent(
        email: email,
        message: 'Verification code has been sent to your email.',
        otpType: OTPType.emailVerification,
      ));

      // العودة لحالة طلب OTP
      await Future.delayed(const Duration(seconds: 2));
      emit(AppAuthOTPRequired(
        email: email,
        otpType: OTPType.emailVerification,
        message: 'Please enter the verification code sent to your email.',
      ));

    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));

      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        emit(AppAuthEmailNotVerified(
          user: currentUser,
          email: currentUser.email ?? '',
          message: 'Please verify your email address to continue.',
        ));
      } else {
        emit(const AppAuthUnauthenticated());
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AppAuthLoading(isGoogleSignIn: true));

      final success = await _authRepository.signInWithGoogle();
      if (!success) {
        emit(const AppAuthError('Google sign in was cancelled or failed.'));
        await Future.delayed(const Duration(seconds: 2));
        emit(const AppAuthUnauthenticated());
      }
    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppAuthUnauthenticated());
    }
  }

  Future<void> signInWithApple() async {
    try {
      emit(const AppAuthLoading(isAppleSignIn: true));

      final success = await _authRepository.signInWithApple();
      if (!success) {
        emit(const AppAuthError('Apple sign in was cancelled or failed.'));
        await Future.delayed(const Duration(seconds: 2));
        emit(const AppAuthUnauthenticated());
      }
    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      emit(const AppAuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(const AppAuthUnauthenticated());
    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      if (state is AppAuthAuthenticated) {
        emit(state);
      }
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      final currentState = state;
      if (currentState is AppAuthAuthenticated) {
        await _authRepository.updateUserProfile(profile);
        emit(AppAuthAuthenticated(
          user: currentState.user,
          profile: profile,
        ));
      }
    } catch (e) {
      emit(AppAuthError(_parseError(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      if (state is AppAuthAuthenticated) {
        emit(state);
      }
    }
  }

  String _parseError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password.';
    } else if (error.contains('Email not confirmed')) {
      return 'Please check your email and confirm your account.';
    } else if (error.contains('weak_password')) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (error.contains('email_address_invalid')) {
      return 'Please enter a valid email address.';
    } else if (error.contains('User already registered')) {
      return 'An account with this email already exists.';
    } else if (error.contains('too_many_requests')) {
      return 'Too many requests. Please try again later.';
    } else if (error.contains('invalid_otp') || error.contains('token_expired')) {
      return 'Invalid or expired verification code. Please try again.';
    }
    return 'An error occurred. Please try again.';
  }

  void resetToUnauthenticated() {
    emit(const AppAuthUnauthenticated());
  }
}