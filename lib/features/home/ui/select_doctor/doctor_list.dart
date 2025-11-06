import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';
import 'package:tabiby/features/home/ui/select_doctor/doctor_card.dart';
import 'package:tabiby/features/home/ui/select_doctor/top_doctors_section.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key, required this.doctors});
final List<Doctor> doctors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(doctor: doctors[index]);
        },
      ),
    );
  }
}