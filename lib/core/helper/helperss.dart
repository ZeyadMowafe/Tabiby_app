// // features/login/ui/widgets/password_field.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';

// class PasswordField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool obscureText;
//   final bool isLoading;
//   final VoidCallback onVisibilityChanged;

//   const PasswordField({
//     Key? key,
//     required this.controller,
//     required this.obscureText,
//     required this.isLoading,
//     required this.onVisibilityChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'كلمة المرور',
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF0F172A),
//           ),
//         ),
//         Gap(8.h),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           enabled: !isLoading,
//           style: TextStyle(
//             fontSize: 15.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF0F172A),
//           ),
//           decoration: InputDecoration(
//             hintText: '••••••••',
//             hintStyle: TextStyle(
//               color: const Color(0xFF94A3B8),
//               fontSize: 15.sp,
//             ),
//             prefixIcon: Icon(
//               Icons.lock_outline,
//               color: const Color(0xFF1E40AF),
//               size: 20.sp,
//             ),
//             suffixIcon: IconButton(
//               onPressed: onVisibilityChanged,
//               icon: Icon(
//                 obscureText
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 color: const Color(0xFF64748B),
//                 size: 20.sp,
//               ),
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF1F5F9),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFF1E40AF),
//                 width: 2,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFFDC2626),
//                 width: 1.5,
//               ),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFFDC2626),
//                 width: 2,
//               ),
//             ),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//             errorStyle: TextStyle(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'الرجاء إدخال كلمة المرور';
//             }
//             if (value.length < 6) {
//               return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }

// // features/login/ui/widgets/email_field.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';

// class EmailField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool isLoading;

//   const EmailField({
//     Key? key,
//     required this.controller,
//     required this.isLoading,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'البريد الإلكتروني',
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//             color: const Color(0xFF0F172A),
//           ),
//         ),
//         Gap(8.h),
//         TextFormField(
//           controller: controller,
//           keyboardType: TextInputType.emailAddress,
//           enabled: !isLoading,
//           style: TextStyle(
//             fontSize: 15.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color(0xFF0F172A),
//           ),
//           decoration: InputDecoration(
//             hintText: 'example@email.com',
//             hintStyle: TextStyle(
//               color: const Color(0xFF94A3B8),
//               fontSize: 15.sp,
//               fontWeight: FontWeight.w400,
//             ),
//             prefixIcon: Icon(
//               Icons.email_outlined,
//               color: const Color(0xFF1E40AF),
//               size: 20.sp,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF1F5F9),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFF1E40AF),
//                 width: 2,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFFDC2626),
//                 width: 1.5,
//               ),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: const BorderSide(
//                 color: Color(0xFFDC2626),
//                 width: 2,
//               ),
//             ),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//             errorStyle: TextStyle(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.trim().isEmpty) {
//               return 'الرجاء إدخال البريد الإلكتروني';
//             }
//             if (!value.contains('@')) {
//               return 'الرجاء إدخال بريد إلكتروني صحيح';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:tabiby/core/theming/color_manager.dart';



// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hintText;
//   final IconData prefixIcon;
//   final bool isPassword;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final bool enabled;
//   final void Function(String)? onChanged; // أضف هذا السطر

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.label,
//     required this.hintText,
//     required this.prefixIcon,
//     this.isPassword = false,
//     this.keyboardType,
//     this.validator,
//     this.enabled = true,
//     this.onChanged, // أضف هذا السطر
//   }) : super(key: key);

//   @override
//   State<CustomTextField> createState() => CustomTextFieldState();
// }

// class CustomTextFieldState extends State<CustomTextField> {
//   bool _isPasswordVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: ColorsManager.gray,
//           ),
//         ),
//         Gap(8.h),
//         TextFormField(
//           controller: widget.controller,
//           keyboardType: widget.keyboardType,
//           obscureText: widget.isPassword && !_isPasswordVisible,
//           validator: widget.validator,
//           enabled: widget.enabled,
//           onChanged: widget.onChanged,
//           style:  TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w500,
//           ),
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//             hintStyle: TextStyle(
//               color: ColorsManager.gray.withOpacity(0.6),
//               fontWeight: FontWeight.w400,
//             ),
//             prefixIcon: Icon(
//               widget.prefixIcon,
//               color: ColorsManager.gray,
//               size: 20,
//             ),
//             suffixIcon: widget.isPassword
//                 ? IconButton(
//               icon: Icon(
//                 _isPasswordVisible
//                     ? Icons.visibility_outlined
//                     : Icons.visibility_off_outlined,
//                 color: ColorsManager.gray,
//                 size: 20,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isPasswordVisible = !_isPasswordVisible;
//                 });
//               },
//             )
//                 : null,
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: ColorsManager.gray.withOpacity(0.2)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: ColorsManager.gray.withOpacity(0.2)),
//             ),
//             focusedBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(12)),
//               borderSide: BorderSide(color: ColorsManager.mainBlue, width: 2),
//             ),
//             errorBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(12)),
//               borderSide: BorderSide(color: ColorsManager.errorRed),
//             ),
//             disabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: ColorsManager.gray.withOpacity(0.1)),
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//         ),
//       ],
//     );
//   }
// }