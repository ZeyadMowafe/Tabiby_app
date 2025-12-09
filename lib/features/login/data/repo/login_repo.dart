import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/core/networking/supabase_server.dart';
import 'package:tabiby/features/login/data/model/user_profile_model.dart';

class LoginRepository {
  final SupabaseService _supabaseService;

  LoginRepository(this._supabaseService);

  // ==================== Getters ====================

  User? get currentUser => _supabaseService.currentUser;

  Session? get currentSession => _supabaseService.currentSession;

  // ==================== Sign In ====================

  Future<AuthResponse> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _logInfo('Attempting sign in for: $email');

      final response = await _supabaseService.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _logSuccess('Sign in successful');
        await _supabaseService.updateEmailVerificationInProfile(response.user!);
      }

      return response;
    } catch (e) {
      _logError('Sign in error', e);
      rethrow;
    }
  }

  // ==================== Social Sign In ====================

  Future<bool> signInWithGoogle() async {
    try {
      _logInfo('Attempting Google sign in');
      final success =
          await _supabaseService.signInWithOAuth(OAuthProvider.google);
      return success;
    } catch (e) {
      _logError('Google sign in error', e);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      _logInfo('Attempting Apple sign in');
      final success =
          await _supabaseService.signInWithOAuth(OAuthProvider.apple);
      return success;
    } catch (e) {
      _logError('Apple sign in error', e);
      return false;
    }
  }

  // ==================== Password Reset ====================

  Future<void> sendPasswordResetOTP(String email) async {
    try {
      _logInfo('Sending password reset OTP to: $email');
      await _supabaseService.resetPasswordForEmail(email);
      _logSuccess('Password reset OTP sent');
    } catch (e) {
      _logError('Send password reset OTP error', e);
      rethrow;
    }
  }

  Future<void> verifyOTPAndResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      _logInfo('Verifying OTP and resetting password for: $email');

      final response = await _supabaseService.verifyOTP(
        type: OtpType.recovery,
        email: email,
        token: token,
      );

      if (response.user == null) {
        throw Exception('Invalid OTP');
      }

      await _supabaseService.updatePassword(newPassword);
      _logSuccess('Password reset successful');
    } catch (e) {
      _logError('Verify OTP and reset password error', e);
      rethrow;
    }
  }

  // ==================== Sign Out ====================

  Future<void> signOut() async {
    try {
      _logInfo('Signing out user');
      await _supabaseService.signOut();
      _logSuccess('User signed out successfully');
    } catch (e) {
      _logError('Sign out error', e);
      rethrow;
    }
  }

  // ==================== Profile ====================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      _logInfo('Getting profile for user: $userId');
      final profile = await _supabaseService.getUserProfile(userId);

      if (profile != null) {
        _logSuccess('Profile found for user: $userId');
      } else {
        _logInfo('No profile found for: $userId');
      }

      return profile;
    } catch (e) {
      _logError('Get user profile error', e);
      return null;
    }
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
}
