import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logic/auth_state.dart';
import '../model/user_profile.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;

  Stream<AppAuthState> get authStateStream {
    return _supabase.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user != null) {
        return AppAuthAuthenticated(user: user);
      } else {
        return const AppAuthUnauthenticated();
      }
    });
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('Attempting sign in for: $email');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('Sign in successful');
        await _safeUpdateEmailVerificationStatus(response.user!);
      }

      return response;
    } catch (e) {
      print('❌ Sign in error: $e');
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
      print(' Attempting sign up for: $email');
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName ?? '',
          'phone_number': phoneNumber ?? '',
        },
        emailRedirectTo: 'tabiby://login-callback',
      );

      if (response.user != null) {
        print('✅ Sign up successful, user created: ${response.user!.id}');
        await _ensureUserProfileExists(response.user!);
      }

      return response;
    } catch (e) {
      print('❌ Sign up error: $e');
      rethrow;
    }
  }

  // دالة لإرسال OTP لإعادة تعيين كلمة المرور
  Future<void> sendPasswordResetOTP(String email) async {
    try {
      print('Sending password reset OTP to: $email');
      
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: null, // لا نحتاج redirect URL للـ OTP
      );
      
      print('✅ Password reset OTP sent');
    } catch (e) {
      print('❌ Send password reset OTP error: $e');
      rethrow;
    }
  }


  Future<void> verifyOTPAndResetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      print('Verifying OTP and resetting password for: $email');
    
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.recovery,
        email: email,
        token: token,
      );

      if (response.user != null) {
    
        await _supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );
        
        print('✅ Password reset successful');
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      print('❌ Verify OTP and reset password error: $e');
      rethrow;
    }
  }


Future<void> updateEmailVerificationInProfile(User user) async {
  try {
    print('📧 Updating email verification in profile for: ${user.id}');
    
    final isEmailVerified = user.emailConfirmedAt != null;
    
    await _supabase
        .from('profiles')
        .update({
          'is_verified': isEmailVerified,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);

    print('✅ Email verification updated in profile: $isEmailVerified');
    
  } catch (e) {
    print('⚠️ Update email verification in profile warning: $e');
   
  }
}
  Future<void> sendEmailVerificationOTP(String email) async {
    try {
      print('📧 Sending email verification OTP to: $email');
      
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      
      print('✅ Email verification OTP sent');
    } catch (e) {
      print('❌ Send email verification OTP error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> verifyEmailOTP({
    required String email,
    required String token,
  }) async {
    try {
      print('📧 Verifying email OTP for: $email');
      
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: token,
      );
      
      if (response.user != null) {
        await _safeUpdateEmailVerificationStatus(response.user!);
        print('✅ Email verification successful');
      }
      
      return response;
    } catch (e) {
      print('❌ Verify email OTP error: $e');
      rethrow;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      print('🔍 Attempting Google sign in');
      
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'tabiby://login-callback',
      );
      
      print('✅ Google sign in response: $response');
      return response;
    } catch (e) {
      print('❌ Google Sign In Error: $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      print('🍎 Attempting Apple sign in');
      
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'tabiby://login-callback',
      );
      
      print('✅ Apple sign in response: $response');
      return response;
    } catch (e) {
      print('❌ Apple Sign In Error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      print('🚪 Signing out user');
      await _supabase.auth.signOut();
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Sign out error: $e');
      rethrow;
    }
  }


  @Deprecated('Use sendPasswordResetOTP instead')
  Future<void> resetPassword(String email) async {
    await sendPasswordResetOTP(email);
  }

  Future<UserProfile?> getUserProfile(String userId) async {
  try {
    print('👤 Getting profile for user: $userId');
    
    final response = await _supabase
        .from('profiles')
        .select('id, email, full_name, phone_number, avatar_url, role, is_verified, is_active, city, country')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      print('ℹ️ No profile found for user: $userId');
      
      final currentUserId = currentUser?.id;
      if (currentUserId == userId) {
        await _ensureUserProfileExists(currentUser!);
        
        final retryResponse = await _supabase
            .from('profiles')
            .select('id, email, full_name, phone_number, avatar_url, role, is_verified, is_active, city, country')
            .eq('id', userId)
            .maybeSingle();
        
        return retryResponse != null ? UserProfile.fromJson(retryResponse) : null;
      }
      
      return null;
    }

    print('✅ Profile found for user: $userId with role: ${response['role']}');
    return UserProfile.fromJson(response);
    
  } catch (e) {
    print('❌ Get User Profile Error: $e');
    
    if (e.toString().contains('infinite recursion') || 
        e.toString().contains('42P17')) {
      print('Attempting to get profile without RLS policies');
      return await _getProfileWithoutRLS(userId);
    }
    
    return null;
  }
}


  Future<UserProfile?> _getProfileWithoutRLS(String userId) async {
    try {
      final response = await _supabase.rpc('get_user_profile', 
        params: {'user_id': userId}
      );
      
      return response != null ? UserProfile.fromJson(response) : null;
    } catch (e) {
      print('❌ Get profile without RLS error: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      print('Updating profile for user: ${profile.id}');
      
      await _supabase
          .from('profiles')
          .update({
            ...profile.toJson(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', profile.id);
      
      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Update Profile Error: $e');
      
      if (e.toString().contains('infinite recursion')) {
        throw Exception('Profile update failed due to database policy conflict. Please contact support.');
      }
      
      rethrow;
    }
  }

  Future<void> _ensureUserProfileExists(User user) async {
    try {
      final existingProfile = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();
      
      if (existingProfile != null) {
        print('ℹ️ Profile already exists for user: ${user.id}');
        return;
      }

      print('Creating profile for user: ${user.id}');
      
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
      
      print('✅ Profile created successfully');
      
    } catch (e) {
      print('❌ Ensure profile exists error: $e');
    }
  }

  Future<void> _safeUpdateEmailVerificationStatus(User user) async {
    try {
      print(' Updating email verification status for: ${user.id}');
      
      final isEmailVerified = user.emailConfirmedAt != null;
      
      await _supabase
          .from('profiles')
          .update({
            'is_verified': isEmailVerified,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);

      print('✅ Email verification status updated: $isEmailVerified');
      
    } catch (e) {
      print('Update email verification warning: $e');
    }
  }

  // دالة محدثة لإعادة إرسال رمز التحقق
  Future<void> resendConfirmationEmail(String email) async {
    await sendEmailVerificationOTP(email);
  }

  Future<bool> isEmailVerified(String userId) async {
    try {
      final user = currentUser;
      if (user != null && user.id == userId) {
        return user.emailConfirmedAt != null;
      }

      final response = await _supabase
          .from('profiles')
          .select('is_verified')
          .eq('id', userId)
          .maybeSingle();

      return response?['is_verified'] ?? false;
      
    } catch (e) {
      print('❌ Check email verification error: $e');
      final user = currentUser;
      return user?.emailConfirmedAt != null ?? false;
    }
  }

  bool isSessionValid() {
    final session = currentSession;
    if (session == null) return false;
    
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return false;
    
    return DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000)
        .isAfter(DateTime.now());
  }

  Future<void> refreshSession() async {
    try {
      print(' Refreshing session');
      await _supabase.auth.refreshSession();
      print('✅ Session refreshed successfully');
    } catch (e) {
      print('❌ Session refresh error: $e');
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
      print('❌ Get Current User Error: $e');
      return {
        'user': currentUser,
        'profile': null,
        'session': currentSession,
      };
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      print('✅ Password updated successfully');
    } catch (e) {
      print('❌ Update Password Error: $e');
      rethrow;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      print('✅ Email updated successfully');
    } catch (e) {
      print('❌ Update Email Error: $e');
      rethrow;
    }
  }

  Future<bool> checkConnection() async {
    try {
      await _supabase.from('profiles').select('count').limit(1);
      return true;
    } catch (e) {
      print('❌ Connection check failed: $e');
      return false;
    }
  }

  Future<void> clearLocalData() async {
    try {
      await _supabase.auth.signOut();
      print('✅ Local data cleared');
    } catch (e) {
      print('❌ Clear local data error: $e');
    }
  }
}
