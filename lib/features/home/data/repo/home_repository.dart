// lib/features/home/data/repo/home_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/features/home/data/models/appointment_model.dart';
import 'package:tabiby/features/home/data/models/booking_model.dart';
import 'package:tabiby/features/home/data/models/clinic_model.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';
import 'package:tabiby/features/home/data/models/specialty_model.dart';

class HomeRepository {
  final SupabaseClient _client;

  HomeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  // ==================== Get Specialties ====================
  Future<List<Specialty>> getSpecialties({int limit = 6}) async {
    try {
      print('🔍 Fetching specialties...');
      
      final response = await _client
          .from('specialties')
          .select()
          .eq('is_active', true)
          .order('is_popular', ascending: false)
          .order('name_ar', ascending: true)
          
          .limit(limit);

      print('✅ Specialties fetched: ${response.length}');
      
      return (response as List)
          .map((json) => Specialty.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching specialties: $e');
      rethrow;
    }
  }

  // ==================== Get Top Doctors ====================
  Future<List<Doctor>> getTopDoctors({int limit = 10}) async {
  try {
    print('🔍 Fetching top doctors...');
    
    final response = await _client
        .from('doctor_profiles')
        .select('''
          *,
          profiles!inner(full_name, avatar_url, phone_number, email),
          specialties!inner(id, name_ar, name_en),
          doctor_clinics(
            clinics!inner(name, address)
          )
        ''')
        .eq('is_verified', true)
        .eq('is_available', true)
        .order('rating', ascending: false)
        .limit(limit);

    print('✅ Top doctors fetched: ${response.length}');
    if (response.isNotEmpty) {
      print('📊 First doctor: ${response[0]}');
    }
    
    return (response as List)
        .map((json) => Doctor.fromJson(json))
        .toList();
  } catch (e) {
    print('❌ Error fetching doctors: $e');
    rethrow;
  }
}
  // ==================== Get Clinics ====================
  Future<List<Clinic>> getClinics({int limit = 5}) async {
    try {
      print('🔍 Fetching clinics...');
      
      final response = await _client
          .from('clinics')
          .select('''
            *,
            doctor_clinics(
              doctor_id,
              doctor_profiles!inner(
                id,
                profiles!inner(full_name)
              )
            )
          ''')
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(limit);

      print('✅ Clinics fetched: ${response.length}');
      
      return (response as List)
          .map((json) => Clinic.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching clinics: $e');
      rethrow;
    }
  }

  // ==================== Get Recent Bookings ====================
  Future<List<RecentBooking>> getRecentBookings({int limit = 3}) async {
    try {
      print('🔍 Fetching recent bookings...');
      
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _client
          .from('appointments')
          .select('''
            *,
            doctor_profiles!inner(
              *,
              profiles!inner(full_name, avatar_url),
              doctor_specialties!inner(
                specialties!inner(name_ar)
              )
            ),
            clinics(name, address)
          ''')
          .eq('patient_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      print('✅ Recent bookings fetched: ${response.length}');
      
      return (response as List)
          .map((json) => RecentBooking.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching recent bookings: $e');
      rethrow;
    }
  }

  // ==================== Get Upcoming Appointments ====================
  Future<List<Appointment>> getUpcomingAppointments({int limit = 5}) async {
    try {
      print('🔍 Fetching upcoming appointments...');
      
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now().toIso8601String();

      final response = await _client
          .from('appointments')
          .select('''
            *,
            doctor_profiles!inner(
              *,
              profiles!inner(full_name, avatar_url),
              doctor_specialties!inner(
                specialties!inner(name_ar)
              )
            ),
            clinics(name, address)
          ''')
          .eq('patient_id', userId)
          .gte('appointment_date', now)
          .inFilter('status', ['confirmed', 'pending'])
          .order('appointment_date', ascending: true)
          .limit(limit);

      print('✅ Upcoming appointments fetched: ${response.length}');
      
      return (response as List)
          .map((json) => Appointment.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching upcoming appointments: $e');
      rethrow;
    }
  }

  // ==================== Search Doctors ====================
  Future<List<Doctor>> searchDoctors({
    required String query,
    String? specialtyId,
  }) async {
    try {
      print('🔍 Searching doctors with query: $query');
      
      var queryBuilder = _client
          .from('doctor_profiles')
          .select('''
            *,
            profiles!inner(full_name, avatar_url),
            doctor_specialties!inner(
              specialties!inner(name_ar)
            )
          ''')
          .eq('is_verified', true);

      if (specialtyId != null && specialtyId.isNotEmpty) {
        queryBuilder = queryBuilder.eq('doctor_specialties.specialty_id', specialtyId);
      }

      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike('profiles.full_name', '%$query%');
      }

      final response = await queryBuilder
          .order('rating', ascending: false)
          .limit(20);

      print('✅ Search results: ${response.length}');
      
      return (response as List)
          .map((json) => Doctor.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error searching doctors: $e');
      rethrow;
    }
  }
}