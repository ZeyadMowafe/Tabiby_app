// lib/features/home/ui/widgets/specialties/specialties_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/features/home/data/models/specialty_model.dart';
import 'package:tabiby/features/home/ui/specialties/specialty_card.dart';


class SpecialtiesList extends StatelessWidget {
  final List<Specialty> specialties;
  
  const SpecialtiesList({
    super.key,
    required this.specialties,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
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