import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/features/login/data/model/user_profile_model.dart';


/// Base state for Signup
abstract class SignupState {
  const SignupState();
}

/// Initial state
class SignupInitial extends SignupState {
  const SignupInitial();
}

/// Loading states
class SignupLoading extends SignupState {
  final bool isSignUp;
  final bool isEmailResend;
  final bool isOTPVerification;

  const SignupLoading({
    this.isSignUp = false,
    this.isEmailResend = false,
    this.isOTPVerification = false,
  });
}

/// Email verification states
class SignupEmailNotVerified extends SignupState {
  final User? user;
  final UserProfile? profile;
  final String email;
  final String message;

  const SignupEmailNotVerified({
    this.user,
    this.profile,
    required this.email,
    required this.message,
  });
}

class SignupOTPRequired extends SignupState {
  final String email;
  final String message;

  const SignupOTPRequired({
    required this.email,
    required this.message,
  });
}

class SignupOTPSent extends SignupState {
  final String email;
  final String message;

  const SignupOTPSent({
    required this.email,
    required this.message,
  });
}

/// Success state
class SignupSuccess extends SignupState {
  final User user;
  final UserProfile? profile;

  const SignupSuccess({
    required this.user,
    this.profile,
  });
}

/// Error state
class SignupError extends SignupState {
  final String message;

  const SignupError(this.message);
}