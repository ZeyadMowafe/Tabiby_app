// lib/features/home/ui/widgets/doctors/top_doctors_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';

import 'package:tabiby/features/home/ui/select_doctor/doctor_list.dart';
import 'package:tabiby/features/home/ui/widgets/common/section_header.dart';

class TopDoctorsSection extends StatelessWidget {
  const TopDoctorsSection({super.key, required this.doctors});
final List<Doctor> doctors;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          TextHeader: 'اختر طبيبك',
          SubTextHeader: 'كافة اطباء متخصصين',
        ),
        Gap(16.h),
        DoctorsList(doctors: doctors,),
      ],
    );
  }
}
