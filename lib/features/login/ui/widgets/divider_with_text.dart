// features/login/ui/widgets/divider_with_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: ColorsManager.lighterGray,
            thickness: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            text,
            style: TextStyles.font13GrayRegular,)
          ),
        
        Expanded(
          child: Divider(
            color: ColorsManager.lighterGray,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}