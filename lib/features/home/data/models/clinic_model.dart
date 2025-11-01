class Clinic {
  final String id;
  final String name;
  final String? logo;
  final String address;
  final String city;
  final double rating;
  final int reviewsCount;
  final int doctorsCount;
  final List<String> specialties;
  final bool isOpen;
  final String? openingHours;
  final double? distance;

  Clinic({
    required this.id,
    required this.name,
    this.logo,
    required this.address,
    required this.city,
    required this.rating,
    required this.reviewsCount,
    required this.doctorsCount,
    required this.specialties,
    this.isOpen = false,
    this.openingHours,
    this.distance,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      doctorsCount: json['doctors_count'] as int? ?? 0,
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isOpen: json['is_open'] as bool? ?? false,
      openingHours: json['opening_hours'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }
}