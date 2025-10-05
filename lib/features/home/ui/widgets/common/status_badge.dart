import 'package:flutter/widgets.dart';
import 'package:tabiby/core/theming/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  
  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: backgroundColor.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.statusText.copyWith(color: color),
      ),
    );
  }
}
