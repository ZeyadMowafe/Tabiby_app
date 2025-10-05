import 'package:flutter/material.dart';
import 'package:tabiby/core/theming/colors.dart';
import 'package:tabiby/features/home/data/models/appointment.dart';
import 'package:tabiby/features/home/data/models/health_data.dart';
import 'package:tabiby/features/home/data/models/medication.dart';
import 'package:tabiby/features/home/data/models/report.dart';

class PatientData {
  static const String userName = 'Ahmed Hassan';
  static const String userInitials = 'AH';
  
  static List<HealthData> getHealthData() {
    return [
      HealthData(
        title: 'Heart Rate',
        value: '72',
        unit: 'BPM',
        status: 'Normal',
        icon: Icons.favorite_rounded,
        primaryColor: AppColors.heartRate,
        secondaryColor: AppColors.heartRateSecondary,
      ),
      HealthData(
        title: 'Blood Pressure',
        value: '120/80',
        unit: 'mmHg',
        status: 'Optimal',
        icon: Icons.timeline_rounded,
        primaryColor: AppColors.bloodPressure,
        secondaryColor: AppColors.bloodPressureSecondary,
      ),
      HealthData(
        title: 'Weight',
        value: '75.2',
        unit: 'kg',
        status: 'Stable',
        icon: Icons.monitor_weight_outlined,
        primaryColor: AppColors.weight,
        secondaryColor: AppColors.weightSecondary,
      ),
      HealthData(
        title: 'Steps Today',
        value: '8,427',
        unit: 'steps',
        status: 'Active',
        icon: Icons.directions_walk_rounded,
        primaryColor: AppColors.steps,
        secondaryColor: AppColors.stepsSecondary,
      ),
    ];
  }
  
  static List<Appointment> getUpcomingAppointments() {
    return [
      Appointment(
        doctorName: 'Dr. Sarah Ahmed',
        type: 'Cardiology Checkup',
        time: '10:30 AM',
        date: 'Tomorrow',
        color: AppColors.appointment,
        specialty: 'Cardiologist',
      ),
      Appointment(
        doctorName: 'Dr. Michael Chen',
        type: 'General Consultation',
        time: '2:15 PM',
        date: 'Friday',
        color: AppColors.avatarPrimary,
        specialty: 'General Physician',
      ),
    ];
  }
  
  static List<Report> getRecentReports() {
    return [
      Report(
        title: 'Blood Test Results',
        description: 'All values within normal range',
        date: '2 days ago',
        icon: Icons.bloodtype_rounded,
        color: AppColors.heartRate,
        status: 'Normal',
      ),
      Report(
        title: 'ECG Report',
        description: 'Heart rhythm is regular',
        date: '1 week ago',
        icon: Icons.monitor_heart_rounded,
        color: AppColors.appointment,
        status: 'Normal',
      ),
      Report(
        title: 'X-Ray Chest',
        description: 'No abnormalities detected',
        date: '2 weeks ago',
        icon: Icons.camera_alt_outlined,
        color: AppColors.reports,
        status: 'Clear',
      ),
    ];
  }
  
  static List<Medication> getMedications() {
    return [
      Medication(
        name: 'Aspirin 75mg',
        instructions: 'Take 1 tablet after breakfast',
        time: '8:30 AM',
        color: AppColors.heartRate,
        isTaken: true,
      ),
      Medication(
        name: 'Vitamin D3',
        instructions: 'Take 1 capsule with lunch',
        time: '1:00 PM',
        color: AppColors.reports,
        isTaken: false,
      ),
      Medication(
        name: 'Omega-3',
        instructions: 'Take 2 capsules with dinner',
        time: '7:30 PM',
        color: AppColors.steps,
        isTaken: false,
      ),
    ];
  }
}