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
    _initializeAuthListener();
  }

  // ==================== Initialization ====================
  
  void _initializeAuthListener() {
    _authRepository.authStateStream.listen(
      _handleAuthStateChange,
      onError: _handleAuthError,
    );
  }

  Future<void> _handleAuthStateChange(AppAuthState authState) async {
    if (authState is AppAuthAuthenticated) {
      await _processAuthenticatedUser(authState.user);
    } else if (authState is AppAuthUnauthenticated) {
      emit(authState);
    }
  }

  void _handleAuthError(dynamic error) {
    emit(AppAuthError(_parseErrorMessage(error.toString())));
  }

  // ==================== Authentication Status ====================

  Future<void> checkAuthStatus() async {
    emit(const AppAuthLoading());

    final user = _authRepository.currentUser;
    if (user != null) {
      await _processAuthenticatedUser(user);
    } else {
      emit(const AppAuthUnauthenticated());
    }
  }

  Future<void> _processAuthenticatedUser(User user) async {
    try {
      await _updateUserEmailVerification(user);
      final profile = await _authRepository.getUserProfile(user.id);
      final isEmailVerified = user.emailConfirmedAt != null;

      if (isEmailVerified) {
        emit(AppAuthAuthenticated(user: user, profile: profile));
      } else {
        emit(AppAuthEmailNotVerified(
          user: user,
          profile: profile,
          email: user.email ?? '',
          message: 'Please verify your email address to continue.',
        ));
      }
    } catch (e) {
      emit(AppAuthError(_parseErrorMessage(e.toString())));
    }
  }

  Future<void> _updateUserEmailVerification(User user) async {
    try {
      await _authRepository.updateEmailVerificationInProfile(user);
    } catch (e) {
      // Non-critical operation, log but don't throw
      print('⚠️ Failed to update email verification: $e');
    }
  }

  // ==================== Sign In ====================

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

      await _handleSignInResponse(response, email);
    } catch (e) {
      _handleSignInError(e, email);
    }
  }

  Future<void> _handleSignInResponse(AuthResponse response, String email) async {
    if (response.user == null) {
      await _emitErrorAndReset('Invalid email or password.');
      return;
    }
  }

  void _handleSignInError(dynamic error, String email) {
    final errorMessage = error.toString();
    
    if (errorMessage.contains('Email not confirmed')) {
      emit(AppAuthEmailNotVerified(
        email: email,
        message: 'Please verify your email address before signing in.',
      ));
      return;
    }

    _emitErrorAndReset(_parseErrorMessage(errorMessage));
  }

  // ==================== Sign Up ====================

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

      await _handleSignUpResponse(response, email);
    } catch (e) {
      await _emitErrorAndReset(_parseErrorMessage(e.toString()));
    }
  }

  Future<void> _handleSignUpResponse(AuthResponse response, String email) async {
    if (response.user == null) {
      await _emitErrorAndReset('Sign up failed. Please try again.');
      return;
    }

    if (_isEmailNotVerified(response.user)) {
      emit(AppAuthOTPRequired(
        email: email,
        otpType: OTPType.emailVerification,
        message: 'Please enter the verification code sent to your email.',
      ));
    } else {
      await _loadUserProfile(response.user!);
    }
  }

  bool _isEmailNotVerified(User? user) {
    return user?.emailConfirmedAt == null;
  }

  // ==================== Password Reset ====================

  Future<void> sendPasswordResetOTP(String email) async {
    try {
      emit(const AppAuthLoading(isSendingOTP: true));
      await _authRepository.sendPasswordResetOTP(email);
      
      emit(AppAuthOTPRequired(
        email: email,
        otpType: OTPType.passwordReset,
        message: 'Enter the verification code to reset your password.',
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
      emit(const AppAuthLoading(isOTPVerification: true));

      await _authRepository.verifyOTPAndResetPassword(
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
      final response = await _authRepository.signIn(
        email: email,
        password: newPassword,
      );

      if (response.user != null) {
        await _finalizePasswordResetSignIn(response.user!);
      } else {
        emit(const AppAuthPasswordResetSuccess());
      }
    } catch (e) {
      emit(const AppAuthPasswordResetSuccess());
    }
  }

  Future<void> _finalizePasswordResetSignIn(User user) async {
    await _updateUserEmailVerification(user);
    final profile = await _authRepository.getUserProfile(user.id);
    emit(AppAuthAuthenticated(user: user, profile: profile));
  }

  Future<void> _handlePasswordResetError(
    dynamic error,
    String email,
    String newPassword,
  ) async {
    print('❌ Password reset error: $error');
    
    // Try auto sign-in as fallback
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final response = await _authRepository.signIn(
        email: email,
        password: newPassword,
      );
      
      if (response.user != null) {
        await _finalizePasswordResetSignIn(response.user!);
        return;
      }
    } catch (autoSignInError) {
      print('❌ Auto sign-in failed: $autoSignInError');
    }
    
    emit(AppAuthError(_parseErrorMessage(error.toString())));
    await Future.delayed(const Duration(seconds: 2));
    
    emit(AppAuthOTPRequired(
      email: email,
      otpType: OTPType.passwordReset,
      message: 'Invalid code. Please try again.',
    ));
  }

  // ==================== Email Verification ====================

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
      await _handleEmailVerificationError(e, email);
    }
  }

  Future<void> _handleEmailVerificationError(dynamic error, String email) async {
    emit(AppAuthError(_parseErrorMessage(error.toString())));
    await Future.delayed(const Duration(seconds: 2));
    
    emit(AppAuthOTPRequired(
      email: email,
      otpType: OTPType.emailVerification,
      message: 'Invalid code. Please try again.',
    ));
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      emit(const AppAuthLoading(isEmailResend: true));
      await _authRepository.sendEmailVerificationOTP(email);

      emit(AppAuthOTPSent(
        email: email,
        message: 'Verification code sent to your email.',
        otpType: OTPType.emailVerification,
      ));

      await Future.delayed(const Duration(seconds: 2));
      
      emit(AppAuthOTPRequired(
        email: email,
        otpType: OTPType.emailVerification,
        message: 'Enter the verification code sent to your email.',
      ));
    } catch (e) {
      await _handleResendEmailError(e, email);
    }
  }

  Future<void> _handleResendEmailError(dynamic error, String email) async {
    emit(AppAuthError(_parseErrorMessage(error.toString())));
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

  // ==================== OTP Operations ====================

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

      await Future.delayed(const Duration(seconds: 2));
      
      emit(AppAuthOTPRequired(
        email: email,
        otpType: otpType,
        message: 'Enter the new verification code sent to your email.',
      ));
    } catch (e) {
      await _handleResendOTPError(e, email, otpType);
    }
  }

  Future<void> _handleResendOTPError(
    dynamic error,
    String email,
    OTPType otpType,
  ) async {
    emit(AppAuthError(_parseErrorMessage(error.toString())));
    await Future.delayed(const Duration(seconds: 2));

    emit(AppAuthOTPRequired(
      email: email,
      otpType: otpType,
      message: 'Failed to resend code. Please try again.',
    ));
  }

  // ==================== Social Authentication ====================

  Future<void> signInWithGoogle() async {
    await _handleSocialSignIn(
      () => _authRepository.signInWithGoogle(),
      'Google sign in was cancelled or failed.',
      isGoogleSignIn: true,
    );
  }

  Future<void> signInWithApple() async {
    await _handleSocialSignIn(
      () => _authRepository.signInWithApple(),
      'Apple sign in was cancelled or failed.',
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
      emit(AppAuthLoading(
        isGoogleSignIn: isGoogleSignIn,
        isAppleSignIn: isAppleSignIn,
      ));

      final success = await signInMethod();
      
      if (!success) {
        await _emitErrorAndReset(errorMessage);
      }
    } catch (e) {
      await _emitErrorAndReset(_parseErrorMessage(e.toString()));
    }
  }

  // ==================== Sign Out ====================

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(const AppAuthUnauthenticated());
    } catch (e) {
      emit(AppAuthError(_parseErrorMessage(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      
      if (state is AppAuthAuthenticated) {
        emit(state);
      }
    }
  }

  // ==================== Profile Management ====================

  Future<void> updateProfile(UserProfile profile) async {
    try {
      final currentState = state;
      if (currentState is! AppAuthAuthenticated) return;

      await _authRepository.updateUserProfile(profile);
      
      emit(AppAuthAuthenticated(
        user: currentState.user,
        profile: profile,
      ));
    } catch (e) {
      emit(AppAuthError(_parseErrorMessage(e.toString())));
      await Future.delayed(const Duration(seconds: 2));
      
      if (state is AppAuthAuthenticated) {
        emit(state);
      }
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

  // ==================== Deprecated Methods ====================

  @Deprecated('Use sendPasswordResetOTP instead')
  Future<void> resetPassword(String email) async {
    await sendPasswordResetOTP(email);
  }

  @Deprecated('Use verifyOTPAndResetPassword instead')
  Future<void> updatePassword(String newPassword) async {
    try {
      emit(const AppAuthLoading(isPasswordUpdate: true));
      await _authRepository.updatePassword(newPassword);
      emit(const AppAuthPasswordResetSuccess());
      await Future.delayed(const Duration(seconds: 2));
      await signOut();
    } catch (e) {
      await _emitErrorAndReset(_parseErrorMessage(e.toString()));
    }
  }

  // ==================== Helper Methods ====================

  Future<void> _emitErrorAndReset(String errorMessage) async {
    emit(AppAuthError(errorMessage));
    await Future.delayed(const Duration(seconds: 2));
    emit(const AppAuthUnauthenticated());
  }

  void resetToUnauthenticated() {
    emit(const AppAuthUnauthenticated());
  }

  // ==================== Error Parsing ====================

  String _parseErrorMessage(String error) {
    final errorMap = {
      'Invalid login credentials': 'Invalid email or password.',
      'Email not confirmed': 'Please check your email and confirm your account.',
      'weak_password': 'Password is too weak. Please use a stronger password.',
      'email_address_invalid': 'Please enter a valid email address.',
      'User already registered': 'An account with this email already exists.',
      'too_many_requests': 'Too many requests. Please try again later.',
      'invalid_otp': 'Invalid or expired verification code.',
      'token_expired': 'Invalid or expired verification code.',
    };

    for (final entry in errorMap.entries) {
      if (error.contains(entry.key)) {
        return entry.value;
      }
    }

    return 'An error occurred. Please try again.';
  }
}