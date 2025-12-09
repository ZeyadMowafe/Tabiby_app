import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/core/networking/supabase_server.dart';
import 'package:tabiby/features/login/data/model/user_profile_model.dart';

class SignupRepository {
  final SupabaseService _supabaseService;

  // ✅ Fixed Constructor - إزالة الـ default value
  // عشان GetIt يقدر يحقن الـ dependency بشكل صحيح
  SignupRepository(this._supabaseService);

  // ==================== Getters ====================

  User? get currentUser => _supabaseService.currentUser;

  // ==================== Sign Up ====================

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      _logInfo('Attempting sign up for: $email');

      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName ?? '',
          'phone_number': phoneNumber ?? '',
        },
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

  // ==================== Email Verification ====================

  Future<void> sendEmailVerificationOTP(String email) async {
    try {
      _logInfo('Sending email verification OTP to: $email');
      await _supabaseService.resendOTP(type: OtpType.signup, email: email);
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

      final response = await _supabaseService.verifyOTP(
        type: OtpType.signup,
        email: email,
        token: token,
      );

      if (response.user != null) {
        await _supabaseService.updateEmailVerificationInProfile(response.user!);
        _logSuccess('Email verification successful');
      }

      return response;
    } catch (e) {
      _logError('Verify email OTP error', e);
      rethrow;
    }
  }

  // ==================== Profile ====================

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      _logInfo('Getting profile for user: $userId');
      final profile = await _supabaseService.getUserProfile(userId);
      _logSuccess('Profile found for user: $userId');
      return profile;
    } catch (e) {
      _logError('Get user profile error', e);
      return null;
    }
  }

  // ==================== Private Helpers ====================

  Future<void> _ensureUserProfileExists(User user) async {
    try {
      final existingProfile = await _supabaseService.checkProfileExists(user.id);

      if (existingProfile) {
        _logInfo('Profile already exists for user: ${user.id}');
        return;
      }

      _logInfo('Creating profile for user: ${user.id}');
      await _supabaseService.createUserProfile(
        userId: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] ?? '',
        phoneNumber: user.userMetadata?['phone_number'] ?? '',
        isVerified: user.emailConfirmedAt != null,
      );

      _logSuccess('Profile created successfully');
    } catch (e) {
      _logError('Ensure profile exists error', e);
    }
  }

  // ==================== Logging ====================

  void _logInfo(String message) {
    print('🔐 [Signup] $message');
  }

  void _logSuccess(String message) {
    print('✅ [Signup] $message');
  }

  void _logError(String message, dynamic error) {
    print('❌ [Signup] $message: $error');
  }
}