import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';
import 'package:tabiby/features/home/ui/widgets/minimal_doctor_card.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String _selectedSpecialty = 'الكل';
  String _selectedSort = 'الأعلى تقييماً';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _specialties = [
    'الكل',
    'القلب',
    'الأسنان',
    'العظام',
    'الجلدية',
    'الأطفال',
    'النساء والتوليد',
  ];

  final List<String> _sortOptions = [
    'الأعلى تقييماً',
    'الأقل سعراً',
    'الأكثر خبرة',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundGray,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                color: ColorsManager.white,
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: ColorsManager.primaryColor,
                          size: 28.sp,
                        ),
                        Gap(12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الدكاترة',
                              style: TextStyles.font20PrimaryDarkBold,
                            ),
                            Text(
                              'اختر الدكتور المناسب لك',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorsManager.lightGray,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(16.h),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsManager.moreLighterGray,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'ابحث عن دكتور...',
                          hintStyle: TextStyle(
                            color: ColorsManager.lightGray,
                            fontSize: 14.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: ColorsManager.lightGray,
                            size: 22.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Filters Section
              Container(
                color: ColorsManager.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Row(
                  children: [
                    // Specialty Filter
                    Expanded(
                      child: _buildFilterDropdown(
                        icon: Icons.medical_services_outlined,
                        value: _selectedSpecialty,
                        items: _specialties,
                        onChanged: (value) {
                          setState(() {
                            _selectedSpecialty = value!;
                          });
                        },
                      ),
                    ),
                    Gap(12.w),

                    // Sort Filter
                    Expanded(
                      child: _buildFilterDropdown(
                        icon: Icons.sort,
                        value: _selectedSort,
                        items: _sortOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedSort = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Gap(8.h),

              // Results Count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Row(
                  children: [
                    Text(
                      'تم العثور على ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorsManager.lightGray,
                      ),
                    ),
                    Text(
                      '24 دكتور',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Doctors List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  children: [
                    _buildDoctorCard(
                      name: 'د. محمد أحمد السيد',
                      specialty: 'استشاري أمراض القلب والأوعية الدموية',
                      rating: '4.9',
                      patients: '250',
                      price: '150 جنيه',
                      experience: '15 سنة خبرة',
                      icon: Icons.favorite_outline,
                      available: true,
                    ),
                    Gap(12.h),
                    _buildDoctorCard(
                      name: 'د. سارة علي محمود',
                      specialty: 'استشاري طب وجراحة الأسنان',
                      rating: '4.8',
                      patients: '180',
                      price: '120 جنيه',
                      experience: '12 سنة خبرة',
                      icon: Icons.medical_services_outlined,
                      available: true,
                    ),
                    Gap(12.h),
                    _buildDoctorCard(
                      name: 'د. خالد حسن عبدالله',
                      specialty: 'استشاري جراحة العظام والمفاصل',
                      rating: '4.9',
                      patients: '220',
                      price: '180 جنيه',
                      experience: '18 سنة خبرة',
                      icon: Icons.accessibility_new_outlined,
                      available: false,
                    ),
                    Gap(12.h),
                    _buildDoctorCard(
                      name: 'د. منى إبراهيم حسين',
                      specialty: 'استشاري الأمراض الجلدية والتجميل',
                      rating: '4.7',
                      patients: '195',
                      price: '140 جنيه',
                      experience: '10 سنوات خبرة',
                      icon: Icons.face_outlined,
                      available: true,
                    ),
                    Gap(12.h),
                    _buildDoctorCard(
                      name: 'د. أحمد محمود فتحي',
                      specialty: 'استشاري طب الأطفال وحديثي الولادة',
                      rating: '4.8',
                      patients: '310',
                      price: '130 جنيه',
                      experience: '14 سنة خبرة',
                      icon: Icons.child_care_outlined,
                      available: true,
                    ),
                    Gap(12.h),
                    _buildDoctorCard(
                      name: 'د. نورهان سعيد أحمد',
                      specialty: 'استشاري النساء والتوليد',
                      rating: '4.9',
                      patients: '275',
                      price: '160 جنيه',
                      experience: '16 سنة خبرة',
                      icon: Icons.pregnant_woman_outlined,
                      available: true,
                    ),
                    Gap(24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorsManager.moreLighterGray,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.lighterGray,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: ColorsManager.primaryColor,
            size: 20.sp,
          ),
          isExpanded: true,
          style: TextStyle(
            fontSize: 13.sp,
            color: ColorsManager.primaryDark,
            fontWeight: FontWeight.w500,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18.sp,
                    color: ColorsManager.primaryColor,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required String rating,
    required String patients,
    required String price,
    required String experience,
    required IconData icon,
    required bool available,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.lighterGray.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to doctor details
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Avatar
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        icon,
                        color: ColorsManager.primaryColor,
                        size: 32.sp,
                      ),
                    ),
                    Gap(12.w),

                    // Doctor Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsManager.primaryDark,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: available
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  available ? 'متاح' : 'محجوز',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: available ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(6.h),
                          Text(
                            specialty,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: ColorsManager.lightGray,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(8.h),
                          Text(
                            experience,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(12.h),

                // Stats Row
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: ColorsManager.moreLighterGray,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.star,
                        value: rating,
                        color: Colors.amber,
                      ),
                      Container(
                        width: 1,
                        height: 20.h,
                        color: ColorsManager.lighterGray,
                      ),
                      _buildStatItem(
                        icon: Icons.people_outline,
                        value: '$patients مريض',
                        color: ColorsManager.primaryColor,
                      ),
                      Container(
                        width: 1,
                        height: 20.h,
                        color: ColorsManager.lighterGray,
                      ),
                      _buildStatItem(
                        icon: Icons.payments_outlined,
                        value: price,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                Gap(12.h),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: available ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryColor,
                      disabledBackgroundColor: ColorsManager.lighterGray,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      available ? 'احجز الآن' : 'غير متاح حالياً',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: color,
        ),
        Gap(4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: ColorsManager.primaryDark,
          ),
        ),
      ],
    );
  }
}