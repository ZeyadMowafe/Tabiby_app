import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/features/login/data/model/user_profile_model.dart';


/// Supabase Service - Central service for all Supabase operations
class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== Getters ====================

  User? get currentUser => _supabase.auth.currentUser;

  Session? get currentSession => _supabase.auth.currentSession;

  Stream<AuthState> get authStateStream => _supabase.auth.onAuthStateChange;

  // ==================== Authentication ====================

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      _logInfo('Sign in with password for: $email');
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _logError('Sign in with password error', e);
      rethrow;
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      _logInfo('Sign up for: $email');
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
        emailRedirectTo: 'tabiby://login-callback',
      );
    } catch (e) {
      _logError('Sign up error', e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _logInfo('Signing out');
      await _supabase.auth.signOut();
      _logSuccess('Signed out successfully');
    } catch (e) {
      _logError('Sign out error', e);
      rethrow;
    }
  }

  // ==================== OAuth ====================

  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    try {
      _logInfo('OAuth sign in with: ${provider.name}');
      return await _supabase.auth.signInWithOAuth(
        provider,
        redirectTo: 'tabiby://login-callback',
      );
    } catch (e) {
      _logError('OAuth sign in error', e);
      return false;
    }
  }

  // ==================== OTP ====================

  Future<void> resendOTP({
    required OtpType type,
    required String email,
  }) async {
    try {
      _logInfo('Resending OTP to: $email');
      await _supabase.auth.resend(type: type, email: email);
      _logSuccess('OTP sent successfully');
    } catch (e) {
      _logError('Resend OTP error', e);
      rethrow;
    }
  }

  Future<AuthResponse> verifyOTP({
    required OtpType type,
    required String email,
    required String token,
  }) async {
    try {
      _logInfo('Verifying OTP for: $email');
      return await _supabase.auth.verifyOTP(
        type: type,
        email: email,
        token: token,
      );
    } catch (e) {
      _logError('Verify OTP error', e);
      rethrow;
    }
  }

  // ==================== Password Management ====================

  Future<void> resetPasswordForEmail(String email) async {
    try {
      _logInfo('Reset password for: $email');
      await _supabase.auth.resetPasswordForEmail(email, redirectTo: null);
      _logSuccess('Password reset email sent');
    } catch (e) {
      _logError('Reset password error', e);
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      _logInfo('Updating password');
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
      _logSuccess('Password updated');
    } catch (e) {
      _logError('Update password error', e);
      rethrow;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      _logInfo('Updating email to: $newEmail');
      await _supabase.auth.updateUser(UserAttributes(email: newEmail));
      _logSuccess('Email updated');
    } catch (e) {
      _logError('Update email error', e);
      rethrow;
    }
  }

  // ==================== Profile Management ====================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      _logInfo('Getting profile for: $userId');

      final response = await _supabase
          .from('profiles')
          .select(_profileSelectQuery)
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        _logWarning('No profile found for: $userId');
        return null;
      }

      _logSuccess('Profile retrieved for: $userId');
      return UserProfile.fromJson(response);
    } catch (e) {
      _logError('Get user profile error', e);
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      _logInfo('Updating profile for: ${profile.id}');

      await _supabase.from('profiles').update({
        ...profile.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', profile.id);

      _logSuccess('Profile updated');
    } catch (e) {
      _logError('Update profile error', e);
      rethrow;
    }
  }

  Future<bool> checkProfileExists(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      _logError('Check profile exists error', e);
      return false;
    }
  }

  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String fullName,
    required String phoneNumber,
    required bool isVerified,
  }) async {
    try {
      _logInfo('Creating profile for: $userId');

      await _supabase.from('profiles').upsert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'role': 'patient',
        'is_verified': isVerified,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      _logSuccess('Profile created');
    } catch (e) {
      _logError('Create profile error', e);
      rethrow;
    }
  }

  Future<void> updateEmailVerificationInProfile(User user) async {
    try {
      _logInfo('Updating email verification for: ${user.id}');

      await _supabase.from('profiles').update({
        'is_verified': user.emailConfirmedAt != null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      _logSuccess('Email verification updated');
    } catch (e) {
      _logWarning('Update email verification warning', e);
    }
  }

  // ==================== Session Management ====================

  bool isSessionValid() {
    final session = currentSession;
    if (session == null) return false;

    final expiresAt = session.expiresAt;
    if (expiresAt == null) return false;

    final expirationDate = DateTime.fromMillisecondsSinceEpoch(
      expiresAt * 1000,
    );

    return expirationDate.isAfter(DateTime.now());
  }

  Future<void> refreshSession() async {
    try {
      _logInfo('Refreshing session');
      await _supabase.auth.refreshSession();
      _logSuccess('Session refreshed');
    } catch (e) {
      _logError('Refresh session error', e);
      rethrow;
    }
  }

  // ==================== Connection ====================

  Future<bool> checkConnection() async {
    try {
      await _supabase.from('profiles').select('count').limit(1);
      return true;
    } catch (e) {
      _logError('Connection check failed', e);
      return false;
    }
  }

  // ==================== Constants ====================

  static const String _profileSelectQuery =
      'id, email, full_name, phone_number, avatar_url, role, '
      'is_verified, is_active, city, country';

  // ==================== Logging ====================

  void _logInfo(String message) {
    print('🔵 [Supabase] $message');
  }

  void _logSuccess(String message) {
    print('✅ [Supabase] $message');
  }

  void _logWarning(String message, [dynamic error]) {
    print('⚠️ [Supabase] $message${error != null ? ': $error' : ''}');
  }

  void _logError(String message, dynamic error) {
    print('❌ [Supabase] $message: $error');
  }
}