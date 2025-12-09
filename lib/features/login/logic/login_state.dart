import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/features/login/data/model/user_profile_model.dart';

/// Base state for Login
abstract class LoginState {
  const LoginState();
}

/// Initial state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Loading states
class LoginLoading extends LoginState {
  final bool isSignIn;
  final bool isGoogleSignIn;
  final bool isAppleSignIn;
  final bool isPasswordReset;
  final bool isOTPVerification;
  final bool isSendingOTP;

  const LoginLoading({
    this.isSignIn = false,
    this.isGoogleSignIn = false,
    this.isAppleSignIn = false,
    this.isPasswordReset = false,
    this.isOTPVerification = false,
    this.isSendingOTP = false,
  });
}

/// Success state - User authenticated
class LoginSuccess extends LoginState {
  final User user;
  final UserProfile? profile;

  const LoginSuccess({
    required this.user,
    this.profile,
  });
}

/// Password reset flow states
class LoginPasswordResetOTPSent extends LoginState {
  final String email;
  final String message;

  const LoginPasswordResetOTPSent({
    required this.email,
    required this.message,
  });
}

class LoginPasswordResetOTPRequired extends LoginState {
  final String email;
  final String message;
  final OTPType otpType;
  final String? newPassword; // إضافة كلمة المرور الجديدة

  const LoginPasswordResetOTPRequired(
    this.otpType, {
    required this.email,
    required this.message,
    this.newPassword,
  });
}

enum OTPType {
  emailVerification,
  passwordReset,
}

class LoginPasswordResetSuccess extends LoginState {
  const LoginPasswordResetSuccess();
}

/// Error state
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);
}

/// Email verification success state
class LoginEmailVerificationSuccess extends LoginState {
  const LoginEmailVerificationSuccess();
}

/// Logout state
class LoginLoggedOut extends LoginState {
  const LoginLoggedOut();
}