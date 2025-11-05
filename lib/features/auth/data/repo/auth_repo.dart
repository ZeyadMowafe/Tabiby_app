import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/auth_state.dart';
import '../model/user_profile.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== Getters ====================

  User? get currentUser => _supabase.auth.currentUser;
  
  Session? get currentSession => _supabase.auth.currentSession;

  Stream<AppAuthState> get authStateStream {
    return _supabase.auth.onAuthStateChange.map(_mapAuthStateChange);
  }



  // ==================== Authentication ====================

  Future<AuthResponse> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      _logInfo('Attempting sign in for: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _logSuccess('Sign in successful');
        await _updateEmailVerificationStatus(response.user!);
      }

      return response;
    } catch (e) {
      _logError('Sign in error', e);
      rethrow;
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      _logInfo('Attempting sign up for: $email');

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: _buildUserMetadata(fullName, phoneNumber),
        emailRedirectTo: 'tabiby://login-callback',
      );

      if (response.user != null) {
        _logSuccess('Sign up successful, user: ${response.user!.id}');
        await _ensureUserProfileExists(response.user!);
      }

      return response;
    } catch (e) {
      _logError('Sign up error', e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _logInfo('Signing out user');
      await _supabase.auth.signOut();
      _logSuccess('User signed out successfully');
    } catch (e) {
      _logError('Sign out error', e);
      rethrow;
    }
  }

  // ==================== Social Authentication ====================

  Future<bool> signInWithGoogle() async {
    return await _handleSocialSignIn(
      OAuthProvider.google,
      'Google',
    );
  }

  Future<bool> signInWithApple() async {
    return await _handleSocialSignIn(
      OAuthProvider.apple,
      'Apple',
    );
  }

  Future<bool> _handleSocialSignIn(
    OAuthProvider provider,
    String providerName,
  ) async {
    try {
      _logInfo('Attempting $providerName sign in');

      final response = await _supabase.auth.signInWithOAuth(
        provider,
        redirectTo: 'tabiby://login-callback',
      );

      _logSuccess('$providerName sign in response: $response');
      return response;
    } catch (e) {
      _logError('$providerName sign in error', e);
      return false;
    }
  }

  // ==================== Password Reset ====================

  Future<void> sendPasswordResetOTP(String email) async {
    try {
      _logInfo('Sending password reset OTP to: $email');

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: null,
      );

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

      final response = await _supabase.auth.verifyOTP(
        type: OtpType.recovery,
        email: email,
        token: token,
      );

      if (response.user == null) {
        throw Exception('Invalid OTP');
      }

      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      _logSuccess('Password reset successful');
    } catch (e) {
      _logError('Verify OTP and reset password error', e);
      rethrow;
    }
  }

  @Deprecated('Use sendPasswordResetOTP instead')
  Future<void> resetPassword(String email) async {
    await sendPasswordResetOTP(email);
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _logSuccess('Password updated successfully');
    } catch (e) {
      _logError('Update password error', e);
      rethrow;
    }
  }

  // ==================== Email Verification ====================

  Future<void> sendEmailVerificationOTP(String email) async {
    try {
      _logInfo('Sending email verification OTP to: $email');

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );

      _logSuccess('Email verification OTP sent');
    } catch (e) {
      _logError('Send email verification OTP error', e);
      rethrow;
    }
  }

  Future<AuthResponse> verifyEmailOTP({
    required String email,
    required String token,
  }) async {
    try {
      _logInfo('Verifying email OTP for: $email');

      final response = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: token,
      );

      if (response.user != null) {
        await _updateEmailVerificationStatus(response.user!);
        _logSuccess('Email verification successful');
      }

      return response;
    } catch (e) {
      _logError('Verify email OTP error', e);
      rethrow;
    }
  }

  Future<void> updateEmailVerificationInProfile(User user) async {
    try {
      _logInfo('Updating email verification in profile for: ${user.id}');

      await _supabase.from('profiles').update({
        'is_verified': user.emailConfirmedAt != null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      _logSuccess('Email verification updated in profile');
    } catch (e) {
      _logWarning('Update email verification in profile warning', e);
    }
  }

  @Deprecated('Use sendEmailVerificationOTP instead')
  Future<void> resendConfirmationEmail(String email) async {
    await sendEmailVerificationOTP(email);
  }

  Future<bool> isEmailVerified(String userId) async {
    try {
      if (currentUser != null && currentUser!.id == userId) {
        return currentUser!.emailConfirmedAt != null;
      }

      final response = await _supabase
          .from('profiles')
          .select('is_verified')
          .eq('id', userId)
          .maybeSingle();

      return response?['is_verified'] ?? false;
    } catch (e) {
      _logError('Check email verification error', e);
      return currentUser?.emailConfirmedAt != null ?? false;
    }
  }

  // ==================== Profile Management ====================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      _logInfo('Getting profile for user: $userId');

      final response = await _supabase
          .from('profiles')
          .select(_profileSelectQuery)
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return await _handleMissingProfile(userId);
      }

      _logSuccess('Profile found for user: $userId');
      return UserProfile.fromJson(response);
    } catch (e) {
      _logError('Get user profile error', e);
      return await _handleProfileError(e, userId);
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      _logInfo('Updating profile for user: ${profile.id}');

      await _supabase.from('profiles').update({
        ...profile.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', profile.id);

      _logSuccess('Profile updated successfully');
    } catch (e) {
      _logError('Update profile error', e);

      if (e.toString().contains('infinite recursion')) {
        throw Exception(
          'Profile update failed due to database policy conflict. '
          'Please contact support.',
        );
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserWithProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final profile = await getUserProfile(user.id);

      return {
        'user': user,
        'profile': profile,
        'session': currentSession,
      };
    } catch (e) {
      _logError('Get current user error', e);
      return {
        'user': currentUser,
        'profile': null,
        'session': currentSession,
      };
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
      _logSuccess('Session refreshed successfully');
    } catch (e) {
      _logError('Session refresh error', e);
      rethrow;
    }
  }

  // ==================== Email Update ====================

  Future<void> updateEmail(String newEmail) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      _logSuccess('Email updated successfully');
    } catch (e) {
      _logError('Update email error', e);
      rethrow;
    }
  }

  // ==================== Connection & Data ====================

  Future<bool> checkConnection() async {
    try {
      await _supabase.from('profiles').select('count').limit(1);
      return true;
    } catch (e) {
      _logError('Connection check failed', e);
      return false;
    }
  }

  Future<void> clearLocalData() async {
    try {
      await _supabase.auth.signOut();
      _logSuccess('Local data cleared');
    } catch (e) {
      _logError('Clear local data error', e);
    }
  }

  // ==================== Private Helper Methods ====================

  AppAuthState _mapAuthStateChange(AuthState data) {
    final user = data.session?.user;
    return user != null
        ? AppAuthAuthenticated(user: user)
        : const AppAuthUnauthenticated();
  }

  Map<String, dynamic> _buildUserMetadata(
    String? fullName,
    String? phoneNumber,
  ) {
    return {
      'full_name': fullName ?? '',
      'phone_number': phoneNumber ?? '',
    };
  }

  Future<void> _ensureUserProfileExists(User user) async {
    try {
      final existingProfile = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (existingProfile != null) {
        _logInfo('Profile already exists for user: ${user.id}');
        return;
      }

      _logInfo('Creating profile for user: ${user.id}');

      await _supabase.from('profiles').insert({
        'id': user.id,
        'email': user.email ?? '',
        'full_name': user.userMetadata?['full_name'] ?? '',
        'phone_number': user.userMetadata?['phone_number'] ?? '',
        'role': 'patient',
        'is_verified': user.emailConfirmedAt != null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      _logSuccess('Profile created successfully');
    } catch (e) {
      _logError('Ensure profile exists error', e);
    }
  }

  Future<void> _updateEmailVerificationStatus(User user) async {
    try {
      _logInfo('Updating email verification status for: ${user.id}');

      await _supabase.from('profiles').update({
        'is_verified': user.emailConfirmedAt != null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      _logSuccess('Email verification status updated');
    } catch (e) {
      _logWarning('Update email verification warning', e);
    }
  }

  Future<UserProfile?> _handleMissingProfile(String userId) async {
    _logInfo('No profile found for user: $userId');

    if (currentUser?.id == userId) {
      await _ensureUserProfileExists(currentUser!);

      final retryResponse = await _supabase
          .from('profiles')
          .select(_profileSelectQuery)
          .eq('id', userId)
          .maybeSingle();

      return retryResponse != null
          ? UserProfile.fromJson(retryResponse)
          : null;
    }

    return null;
  }

  Future<UserProfile?> _handleProfileError(
    dynamic error,
    String userId,
  ) async {
    if (_isRLSPolicyError(error)) {
      _logInfo('Attempting to get profile without RLS policies');
      return await _getProfileWithoutRLS(userId);
    }
    return null;
  }

  bool _isRLSPolicyError(dynamic error) {
    final errorString = error.toString();
    return errorString.contains('infinite recursion') ||
        errorString.contains('42P17');
  }

  Future<UserProfile?> _getProfileWithoutRLS(String userId) async {
    try {
      final response = await _supabase.rpc(
        'get_user_profile',
        params: {'user_id': userId},
      );

      return response != null ? UserProfile.fromJson(response) : null;
    } catch (e) {
      _logError('Get profile without RLS error', e);
      return null;
    }
  }

  // ==================== Constants ====================

  static const String _profileSelectQuery =
      'id, email, full_name, phone_number, avatar_url, role, '
      'is_verified, is_active, city, country';

  // ==================== Logging ====================

  void _logInfo(String message) {
    print('🔐 $message');
  }

  void _logSuccess(String message) {
    print('✅ $message');
  }

  void _logWarning(String message, dynamic error) {
    print('⚠️ $message: $error');
  }

  void _logError(String message, dynamic error) {
    print('❌ $message: $error');
  }
}