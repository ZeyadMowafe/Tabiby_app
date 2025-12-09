import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundGray,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with Profile Info
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorsManager.primaryColor,
                        ColorsManager.primaryColor.withOpacity(0.85),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Gap(20.h),
                      // Profile Picture
                      Stack(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorsManager.white,
                              border: Border.all(
                                color: ColorsManager.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 50.sp,
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                // تغيير الصورة
                              },
                              child: Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  color: ColorsManager.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsManager.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16.sp,
                                  color: ColorsManager.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(16.h),
                      Text(
                        'أحمد محمد علي',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Gap(6.h),
                      Text(
                        'ahmed.mohamed@email.com',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorsManager.white.withOpacity(0.9),
                          letterSpacing: 0.2,
                        ),
                      ),
                      Gap(20.h),
                      // Stats Row
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.w),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: ColorsManager.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: ColorsManager.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('12', 'الحجوزات'),
                            Container(
                              width: 1,
                              height: 30.h,
                              color: ColorsManager.white.withOpacity(0.3),
                            ),
                            _buildStatItem('8', 'المكتملة'),
                            Container(
                              width: 1,
                              height: 30.h,
                              color: ColorsManager.white.withOpacity(0.3),
                            ),
                            _buildStatItem('4', 'القادمة'),
                          ],
                        ),
                      ),
                      Gap(20.h),
                    ],
                  ),
                ),

                Gap(20.h),

                // Menu Items
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Account Section
                      _buildSectionTitle('حسابي'),
                      Gap(12.h),
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'المعلومات الشخصية',
                        subtitle: 'الاسم، البريد، رقم الهاتف',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.credit_card_outlined,
                        title: 'طرق الدفع',
                        subtitle: 'البطاقات والمحافظ الإلكترونية',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'عناويني',
                        subtitle: 'إدارة عناوين المنزل والعمل',
                        onTap: () {},
                      ),

                      Gap(20.h),

                      // Medical Section
                      _buildSectionTitle('الملف الطبي'),
                      Gap(12.h),
                      _buildMenuItem(
                        icon: Icons.medical_information_outlined,
                        title: 'السجل الطبي',
                        subtitle: 'تاريخ الحالات والأمراض',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.medication_outlined,
                        title: 'الأدوية الحالية',
                        subtitle: 'قائمة الأدوية المستمرة',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.vaccines_outlined,
                        title: 'الحساسية',
                        subtitle: 'حساسية الأدوية والأطعمة',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.bloodtype_outlined,
                        title: 'فصيلة الدم',
                        subtitle: 'معلومات فصيلة الدم',
                        onTap: () {},
                      ),

                      Gap(20.h),

                      // Settings Section
                      _buildSectionTitle('الإعدادات'),
                      Gap(12.h),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'الإشعارات',
                        subtitle: 'إشعارات المواعيد والتذكيرات',
                        onTap: () {},
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: ColorsManager.primaryColor,
                        ),
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.language_outlined,
                        title: 'اللغة',
                        subtitle: 'العربية',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.lock_outline,
                        title: 'تغيير كلمة المرور',
                        subtitle: 'تحديث بيانات الدخول',
                        onTap: () {},
                      ),

                      Gap(20.h),

                      // Support Section
                      _buildSectionTitle('المساعدة والدعم'),
                      Gap(12.h),
                      _buildMenuItem(
                        icon: Icons.star_outline,
                        title: 'الأطباء المفضلون',
                        subtitle: 'قائمة الأطباء المحفوظين',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'مركز المساعدة',
                        subtitle: 'الأسئلة الشائعة والدعم الفني',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.phone_outlined,
                        title: 'تواصل معنا',
                        subtitle: 'اتصل بفريق الدعم',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'الخصوصية',
                        subtitle: 'سياسة الخصوصية وحماية البيانات',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.description_outlined,
                        title: 'الشروط والأحكام',
                        subtitle: 'شروط استخدام التطبيق',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.star_rate_outlined,
                        title: 'قيم التطبيق',
                        subtitle: 'شارك رأيك في المتجر',
                        onTap: () {},
                      ),
                      Gap(8.h),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'عن التطبيق',
                        subtitle: 'الإصدار 1.0.0',
                        onTap: () {},
                      ),

                      Gap(20.h),

                      // Logout Button
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: ColorsManager.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: ColorsManager.borderGray,
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Row(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  color: ColorsManager.errorRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  size: 22.sp,
                                  color: ColorsManager.errorRed,
                                ),
                              ),
                              Gap(16.w),
                              Expanded(
                                child: Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsManager.errorRed,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_ios,
                                size: 16.sp,
                                color: ColorsManager.errorRed,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Gap(24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: ColorsManager.white,
            letterSpacing: 0.2,
          ),
        ),
        Gap(4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorsManager.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: ColorsManager.primaryDark,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorsManager.borderGray,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: ColorsManager.lightBlueBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 22.sp,
                  color: ColorsManager.primaryColor,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.primaryDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsManager.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              trailing ??
                  Icon(
                    Icons.arrow_back_ios,
                    size: 16.sp,
                    color: ColorsManager.lightGray,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: ColorsManager.errorRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    size: 32.sp,
                    color: ColorsManager.errorRed,
                  ),
                ),
                Gap(20.h),
                Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.primaryDark,
                  ),
                ),
                Gap(12.h),
                Text(
                  'هل أنت متأكد من تسجيل الخروج من حسابك؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.textGray,
                  ),
                ),
                Gap(24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: ColorsManager.borderGray,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.primaryDark,
                          ),
                        ),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // تنفيذ تسجيل الخروج
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.errorRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                        ),
                        child: Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}