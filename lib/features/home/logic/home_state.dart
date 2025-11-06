// lib/features/home/logic/home_state.dart
import '../data/models/doctor_model.dart';
import '../data/models/clinic_model.dart';
import '../data/models/specialty_model.dart';
import '../data/models/appointment_model.dart';
import '../data/models/booking_model.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Specialty> specialties;
  final List<Doctor> Doctors;
  final List<Clinic> clinics;
  final List<RecentBooking> recentBookings;
  final List<Appointment> upcomingAppointments;

  const HomeLoaded({
    required this.specialties,
    required this.Doctors,
    required this.clinics,
    required this.recentBookings,
    required this.upcomingAppointments,
  });
}

class HomeSearching extends HomeState {
  const HomeSearching();
}

class HomeSearchResults extends HomeState {
  final List<Doctor> doctors;

  const HomeSearchResults({required this.doctors});
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}