// lib/features/home/data/models/specialty_model.dart
import 'package:flutter/material.dart';

class Specialty {
  final String id;
  final String name;
  final String icon;
  final String? colorHex; // غيّرت من Color إلى String
  final int doctorsCount;
  final bool isPopular;

  Specialty({
    required this.id,
    required this.name,
    required this.icon,
    this.colorHex,
    required this.doctorsCount,
    this.isPopular = false,
  });

  // دالة لتحويل الـ hex string إلى Color
  Color get color {
    if (colorHex == null || colorHex!.isEmpty) {
      return const Color(0xFF3B82F6); // لون افتراضي
    }
    
    try {
      // إزالة # لو موجود
      String hexColor = colorHex!.replaceAll('#', '');
      
      // إضافة FF للشفافية لو مش موجودة
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return const Color(0xFF3B82F6); // لون افتراضي في حالة الخطأ
    }
  }

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id']?.toString() ?? '',
      name: json['name_ar']?.toString() ?? 'غير محدد',
      icon: json['icon']?.toString() ?? 'medical_services_rounded',
      colorHex: json['color']?.toString(), // احفظها كـ String
      doctorsCount: 0,
      isPopular: (json['is_popular'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': name,
      'icon': icon,
      'color': colorHex,
      'is_popular': isPopular,
    };
  }
}