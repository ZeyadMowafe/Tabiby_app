class Doctor {
  final String id;
  final String name;
  final String specialtyId;
  final String specialtyName;
  final String? photo;
  final double rating;
  final int reviewsCount;
  final int experience;
  final double consultationFee;
  final bool isAvailable;
  final String? nextAvailableSlot;
  final String? clinicName;
  final String? clinicAddress;

  Doctor({
    required this.id,
    required this.name,
    required this.specialtyId,
    required this.specialtyName,
    this.photo,
    required this.rating,
    required this.reviewsCount,
    required this.experience,
    required this.consultationFee,
    this.isAvailable = false,
    this.nextAvailableSlot,
    this.clinicName,
    this.clinicAddress,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialtyId: json['specialty_id'] as String,
      specialtyName: json['specialty_name'] as String,
      photo: json['photo'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      experience: json['experience'] as int? ?? 0,
      consultationFee: (json['consultation_fee'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] as bool? ?? false,
      nextAvailableSlot: json['next_available_slot'] as String?,
      clinicName: json['clinic_name'] as String?,
      clinicAddress: json['clinic_address'] as String?,
    );
  }
}