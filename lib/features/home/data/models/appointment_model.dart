enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String? doctorPhoto;
  final String specialtyName;
  final String clinicName;
  final DateTime dateTime;
  final String timeSlot;
  final AppointmentStatus status;
  final double fee;
  final String? notes;
  final String? cancelReason;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.doctorPhoto,
    required this.specialtyName,
    required this.clinicName,
    required this.dateTime,
    required this.timeSlot,
    required this.status,
    required this.fee,
    this.notes,
    this.cancelReason,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String,
      doctorName: json['doctor_name'] as String,
      doctorPhoto: json['doctor_photo'] as String?,
      specialtyName: json['specialty_name'] as String,
      clinicName: json['clinic_name'] as String,
      dateTime: DateTime.parse(json['date_time'] as String),
      timeSlot: json['time_slot'] as String,
      status: _parseStatus(json['status'] as String?),
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      cancelReason: json['cancel_reason'] as String?,
    );
  }

  static AppointmentStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.pending;
    }
  }

  bool get isUpcoming {
    return dateTime.isAfter(DateTime.now()) &&
        (status == AppointmentStatus.pending ||
            status == AppointmentStatus.confirmed);
  }

  bool get isPast {
    return dateTime.isBefore(DateTime.now()) ||
        status == AppointmentStatus.completed;
  }
}