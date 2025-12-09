import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository _repository;

  // ✅ Fixed Constructor - إزالة الـ default value
  SignupCubit(this._repository) : super(const SignupInitial());

  // ==================== Sign Up ====================

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      emit(const SignupLoading(isSignUp: true));

      final response = await _repository.signUp(
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
      emit(SignupOTPRequired(
        email: email,
        message: 'Please enter the verification code sent to your email.',
      ));
    } else {
      await _loadUserProfile(response.user!);
    }
  }

  bool _isEmailNotVerified(User? user) {
    return user?.emailConfirmedAt == null;
  }

  // ==================== Email Verification ====================

  Future<void> verifyEmailOTP({
    required String email,
    required String otp,
  }) async {
    try {
      emit(const SignupLoading(isOTPVerification: true));

      final response = await _repository.verifyEmailOTP(
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
    emit(SignupError(_parseErrorMessage(error.toString())));
    await Future.delayed(const Duration(seconds: 2));

    emit(SignupOTPRequired(
      email: email,
      message: 'Invalid code. Please try again.',
    ));
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      emit(const SignupLoading(isEmailResend: true));
      await _repository.sendEmailVerificationOTP(email);

      emit(SignupOTPSent(
        email: email,
        message: 'Verification code sent to your email.',
      ));

      await Future.delayed(const Duration(seconds: 2));

      emit(SignupOTPRequired(
        email: email,
        message: 'Enter the verification code sent to your email.',
      ));
    } catch (e) {
      await _handleResendEmailError(e, email);
    }
  }

  Future<void> _handleResendEmailError(dynamic error, String email) async {
    emit(SignupError(_parseErrorMessage(error.toString())));
    await Future.delayed(const Duration(seconds: 2));

    final currentUser = _repository.currentUser;
    if (currentUser != null) {
      emit(SignupEmailNotVerified(
        user: currentUser,
        email: currentUser.email ?? '',
        message: 'Please verify your email address to continue.',
      ));
    } else {
      emit(const SignupInitial());
    }
  }

  // ==================== Helper Methods ====================

  Future<void> _loadUserProfile(User user) async {
    try {
      final profile = await _repository.getUserProfile(user.id);
      emit(SignupSuccess(user: user, profile: profile));
    } catch (e) {
      emit(SignupSuccess(user: user));
    }
  }

  Future<void> _emitErrorAndReset(String errorMessage) async {
    emit(SignupError(errorMessage));
    await Future.delayed(const Duration(seconds: 2));
    emit(const SignupInitial());
  }

  void resetToInitial() {
    emit(const SignupInitial());
  }

  // ==================== Error Parsing ====================

  String _parseErrorMessage(String error) {
    final errorMap = {
      'User already registered': 'An account with this email already exists.',
      'weak_password': 'Password is too weak. Please use a stronger password.',
      'email_address_invalid': 'Please enter a valid email address.',
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