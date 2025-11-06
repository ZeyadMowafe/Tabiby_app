import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/doctor_model.dart';
import 'package:tabiby/features/home/ui/select_doctor/card_body_doctor.dart';
import 'package:tabiby/features/home/ui/select_doctor/card_footer_doctor.dart';
import 'package:tabiby/features/home/ui/select_doctor/card_header_doctor.dart';


class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        elevation: 0,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 236, 236, 236),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardHeaderDoctor(doctor: doctor),
                CardBody(doctor: doctor),
                CardFooterDoctor(doctor: doctor),
              ],
            ),
          ),
        ),
      ),
    );
  }

 



  

 



}