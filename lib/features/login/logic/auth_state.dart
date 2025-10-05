import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/model/user_profile.dart';

abstract class AppAuthState {
  const AppAuthState();
}

class AuthInitial extends AppAuthState {
  const AuthInitial();
}

class AppAuthLoading extends AppAuthState {
  final bool isSignIn;
  final bool isSignUp;
  final bool isGoogleSignIn;
  final bool isAppleSignIn;
  final bool isPasswordReset;
  final bool isEmailResend;
  final bool isPasswordUpdate;
  final bool isOTPVerification;
  final bool isSendingOTP; 

  const AppAuthLoading({
    this.isSignIn = false,
    this.isSignUp = false,
    this.isGoogleSignIn = false,
    this.isAppleSignIn = false,
    this.isPasswordReset = false,
    this.isEmailResend = false,
    this.isPasswordUpdate = false,
    this.isOTPVerification = false,
    this.isSendingOTP = false,
  });
}

class AppAuthAuthenticated extends AppAuthState {
  final User user;
  final UserProfile? profile;

  const AppAuthAuthenticated({
    required this.user,
    this.profile,
  });
}

class AppAuthUnauthenticated extends AppAuthState {
  const AppAuthUnauthenticated();
}

class AppAuthEmailNotVerified extends AppAuthState {
  final User? user;
  final UserProfile? profile;
  final String email;
  final String message;

  const AppAuthEmailNotVerified({
    this.user,
    this.profile,
    required this.email,
    required this.message,
  });
}


class AppAuthOTPSent extends AppAuthState {
  final String email;
  final String message;
  final OTPType otpType;

  const AppAuthOTPSent({
    required this.email,
    required this.message,
    required this.otpType,
  });
}

enum OTPType {
  emailVerification,
  passwordReset,
}


class AppAuthOTPRequired extends AppAuthState {
  final String email;
  final OTPType otpType;
  final String message;

  const AppAuthOTPRequired({
    required this.email,
    required this.otpType,
    required this.message,
  });
}


class AppAuthEmailSent extends AppAuthState {
  final String email;
  final String message;

  const AppAuthEmailSent(this.email, this.message);
}

class AppAuthPasswordResetSuccess extends AppAuthState {
  const AppAuthPasswordResetSuccess();
}

class AppAuthError extends AppAuthState {
  final String message;

  const AppAuthError(this.message);
}
