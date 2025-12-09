

// features/login/ui/widgets/universal_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum FieldType {
  email,
  password,
  text,
  phone,
  // يمكنك إضافة المزيد حسب احتياجاتك
}

class UniversalField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final FieldType fieldType;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final VoidCallback? onVisibilityChanged;
  final String? Function(String?)? customValidator;

  const UniversalField({
    Key? key,
    required this.controller,
    required this.isLoading,
    required this.fieldType,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.onVisibilityChanged,
    this.customValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        Gap(8.h),
        TextFormField(
          controller: controller,
          keyboardType: _getKeyboardType(),
          obscureText: obscureText,
          enabled: !isLoading,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0xFF1E40AF),
              size: 20.sp,
            ),
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF1E40AF),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFDC2626),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFDC2626),
                width: 2,
              ),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            errorStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          validator: customValidator ?? _defaultValidator,
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (fieldType == FieldType.password) {
      return IconButton(
        onPressed: onVisibilityChanged,
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: const Color(0xFF64748B),
          size: 20.sp,
        ),
      );
    }
    return null;
  }

  TextInputType _getKeyboardType() {
    switch (fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.password:
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  String? _defaultValidator(String? value) {
    switch (fieldType) {
      case FieldType.email:
        if (value == null || value.trim().isEmpty) {
          return 'الرجاء إدخال البريد الإلكتروني';
        }
        if (!value.contains('@')) {
          return 'الرجاء إدخال بريد إلكتروني صحيح';
        }
        return null;
      
      case FieldType.password:
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال كلمة المرور';
        }
        if (value.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      
      default:
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
    }
  }
}