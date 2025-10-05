import 'dart:ui';

class Appointment {
  final String doctorName;
  final String type;
  final String time;
  final String date;
  final Color color;
  final String specialty;

  const Appointment({
    required this.doctorName,
    required this.type,
    required this.time,
    required this.date,
    required this.color,
    required this.specialty,
  });
}