import 'dart:ui';

class Medication {
  final String name;
  final String instructions;
  final String time;
  final Color color;
  final bool isTaken;

  const Medication({
    required this.name,
    required this.instructions,
    required this.time,
    required this.color,
    required this.isTaken,
  });
}