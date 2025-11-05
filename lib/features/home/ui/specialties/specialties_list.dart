import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/features/home/ui/specialties/specialties_section.dart';
import 'package:tabiby/features/home/ui/specialties/specialty_card.dart';

class SpecialtiesList extends StatelessWidget {
  const SpecialtiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: specialties.length,
        itemBuilder: (context, index) {
          return SpecialtyCard(specialty: specialties[index]);
        },
      ),
    );
  }
}
