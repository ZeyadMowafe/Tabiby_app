// lib/features/home/logic/home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/auth/data/repo/auth_repo.dart';
import 'package:tabiby/features/home/data/models/appointment_model.dart';
import 'package:tabiby/features/home/data/models/booking_model.dart';
import 'package:tabiby/features/home/data/models/clinic_model.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';
import 'package:tabiby/features/home/data/models/specialty_model.dart';
import '../data/repo/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit({HomeRepository? repository})
      : _repository = repository ?? HomeRepository(),
        super(const HomeInitial());

  // ==================== Load Home Data ====================
  Future<void> loadHomeData() async {
    try {
      emit(const HomeLoading());
      
      // Get current user
      final user = AuthRepository().currentUser;
      
      if (user == null) {
        emit(const HomeError('User not authenticated'));
        return;
      }

      // Fetch all data in parallel
      final results = await Future.wait([
        _repository.getSpecialties(limit: 6),
        _repository.getTopDoctors(limit: 10),
        _repository.getClinics(limit: 5),
        _repository.getRecentBookings(limit: 3, ),
        _repository.getUpcomingAppointments(limit: 5),
      ]);

      emit(HomeLoaded(
        specialties: results[0] as List<Specialty>,
        Doctors: results[1] as List<Doctor>,
        clinics: results[2] as List<Clinic>,
        recentBookings: results[3] as List<RecentBooking>,
        upcomingAppointments: results[4] as List<Appointment>,
      ));
    } catch (e) {
      emit(HomeError(_parseErrorMessage(e.toString())));
    }
  }

  // ==================== Load Specialties Only ====================
  Future<void> loadSpecialties() async {
    try {
      emit(const HomeLoading());
      
      final specialties = await _repository.getSpecialties(limit: 6);
      
      emit(HomeLoaded(
        specialties: specialties,
        Doctors: const [],
        clinics: const [],
        recentBookings: const [],
        upcomingAppointments: const [],
      ));
    } catch (e) {
      emit(HomeError(_parseErrorMessage(e.toString())));
    }
  }

  // ==================== Refresh Data ====================
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  // ==================== Search Doctors ====================
  Future<void> searchDoctors({
    required String query,
    String? specialtyId,
  }) async {
    try {
      emit(const HomeSearching());

      final doctors = await _repository.searchDoctors(
        query: query,
        specialtyId: specialtyId,
      );

      emit(HomeSearchResults(doctors: doctors));
    } catch (e) {
      emit(HomeError(_parseErrorMessage(e.toString())));
    }
  }

  // ==================== Filter Doctors by Specialty ====================
  Future<void> filterDoctorsBySpecialty(String specialtyId) async {
    try {
      emit(const HomeLoading());
      
      final doctors = await _repository.searchDoctors(
        query: '',
        specialtyId: specialtyId,
      );
      
      emit(HomeSearchResults(doctors: doctors));
    } catch (e) {
      emit(HomeError(_parseErrorMessage(e.toString())));
    }
  }

  // ==================== Error Parsing ====================
  String _parseErrorMessage(String error) {
    if (error.contains('JWT') || error.contains('token')) {
      return 'انتهت الجلسة. الرجاء تسجيل الدخول مرة أخرى.';
    } else if (error.contains('Network') || error.contains('SocketException')) {
      return 'خطأ في الاتصال. تحقق من الإنترنت.';
    } else if (error.contains('User not authenticated')) {
      return 'يجب تسجيل الدخول أولاً.';
    }
    return 'حدث خطأ. حاول مرة أخرى.';
  }
}