class RecentBooking {
  final String id;
  final String doctorName;
  final String? doctorPhoto;
  final String specialtyName;
  final DateTime bookedAt;
  final DateTime appointmentDate;
  final String status;

  RecentBooking({
    required this.id,
    required this.doctorName,
    this.doctorPhoto,
    required this.specialtyName,
    required this.bookedAt,
    required this.appointmentDate,
    required this.status,
  });

  factory RecentBooking.fromJson(Map<String, dynamic> json) {
    return RecentBooking(
      id: json['id'] as String,
      doctorName: json['doctor_name'] as String,
      doctorPhoto: json['doctor_photo'] as String?,
      specialtyName: json['specialty_name'] as String,
      bookedAt: DateTime.parse(json['booked_at'] as String),
      appointmentDate: DateTime.parse(json['appointment_date'] as String),
      status: json['status'] as String,
    );
  }
}