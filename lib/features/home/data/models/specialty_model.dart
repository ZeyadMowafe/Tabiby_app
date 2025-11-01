class Specialty {
  final String id;
  final String name;
  final String icon;
  final int doctorsCount;
  final bool isPopular;

  Specialty({
    required this.id,
    required this.name,
    required this.icon,
    required this.doctorsCount,
    this.isPopular = false,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      doctorsCount: json['doctors_count'] as int? ?? 0,
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }
}