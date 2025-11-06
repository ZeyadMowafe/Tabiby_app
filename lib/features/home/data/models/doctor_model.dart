// lib/features/home/data/models/doctor_model.dart
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
  final String? phoneNumber;
  final String? email;
  final int sale;

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
    this.phoneNumber,
    this.email,
    required this.sale,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // البيانات الأساسية من doctor_profiles
    final doctorData = json;
    
    // البيانات من profiles (nested)
    final profileData = json['profiles'] as Map<String, dynamic>?;
    
    // البيانات من doctor_specialties و specialties (nested)
    final specialtyData = json['doctor_specialties'] is List && 
                          (json['doctor_specialties'] as List).isNotEmpty
        ? (json['doctor_specialties'] as List).first['specialties'] as Map<String, dynamic>?
        : json['specialties'] as Map<String, dynamic>?;
    
    // البيانات من doctor_clinics و clinics (nested)
    final clinicData = json['doctor_clinics'] is List && 
                       (json['doctor_clinics'] as List).isNotEmpty
        ? (json['doctor_clinics'] as List).first['clinics'] as Map<String, dynamic>?
        : json['clinics'] as Map<String, dynamic>?;

    return Doctor(
      id: doctorData['id']?.toString() ?? '',
      name: profileData?['full_name']?.toString() ?? 
            doctorData['full_name']?.toString() ?? 
            'غير محدد',
      specialtyId: doctorData['specialty_id']?.toString() ?? '',
      specialtyName: specialtyData?['name_ar']?.toString() ?? 
                     specialtyData?['name_en']?.toString() ?? 
                     'غير محدد',
      photo: doctorData['photo']?.toString() ?? 
             profileData?['avatar_url']?.toString(),
      rating: (doctorData['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (doctorData['reviews_count'] as int?) ?? 
                    (doctorData['total_reviews'] as int?) ?? 0,
      experience: (doctorData['experience'] as int?) ?? 
                  (doctorData['years_of_experience'] as int?) ?? 0,
      consultationFee: (doctorData['consultation_fee'] as num?)?.toDouble() ?? 0.0,
      isAvailable: (doctorData['is_available'] as bool?) ?? false,
      nextAvailableSlot: doctorData['next_available_slot']?.toString(),
      clinicName: clinicData?['name']?.toString(),
      clinicAddress: clinicData?['address']?.toString(),
      phoneNumber: doctorData['phone_number']?.toString() ?? 
                   profileData?['phone_number']?.toString(),
      email: doctorData['email']?.toString() ?? 
             profileData?['email']?.toString(),
      sale: (doctorData['sale'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty_id': specialtyId,
      'specialty_name': specialtyName,
      'photo': photo,
      'rating': rating,
      'reviews_count': reviewsCount,
      'experience': experience,
      'consultation_fee': consultationFee,
      'is_available': isAvailable,
      'next_available_slot': nextAvailableSlot,
      'clinic_name': clinicName,
      'clinic_address': clinicAddress,
      'phone_number': phoneNumber,
      'email': email,
      'sale': sale,
    };
  }
}