import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/theming/color_manager.dart';
import 'package:tabiby/core/theming/styles.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
                child: Row(
                  children: [
                    Text('حجوزاتي', style: TextStyles.font24PrimaryDarkBold),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: ColorsManager.primaryColor,
                  indicatorWeight: 3.h,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: ColorsManager.primaryColor,
                  unselectedLabelColor: ColorsManager.textGray,
                  labelStyle: TextStyles.font14PrimarySemiBold,
                  unselectedLabelStyle: TextStyles.font14GrayMedium,
                  tabs: const [
                    Tab(text: 'القادمة'),
                    Tab(text: 'المكتملة'),
                    Tab(text: 'الملغاة'),
                  ],
                ),
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUpcomingBookings(),
                    _buildCompletedBookings(),
                    _buildCancelledBookings(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildBookingCard(
          doctorName: 'د. محمد أحمد السيد',
          specialty: 'استشاري أمراض القلب',
          date: 'الأحد، 10 ديسمبر 2024',
          time: '10:00 صباحاً',
          location: 'عيادة القلب - الدور الثاني',
          price: '150 جنيه',
          status: 'upcoming',
          bookingNumber: '#12345',
        ),
        Gap(12.h),
        _buildBookingCard(
          doctorName: 'د. سارة علي محمود',
          specialty: 'استشاري طب الأسنان',
          date: 'الإثنين، 11 ديسمبر 2024',
          time: '03:00 مساءً',
          location: 'عيادة الأسنان - الدور الأول',
          price: '120 جنيه',
          status: 'upcoming',
          bookingNumber: '#12346',
        ),
        Gap(12.h),
        _buildBookingCard(
          doctorName: 'د. خالد حسن عبدالله',
          specialty: 'استشاري جراحة العظام',
          date: 'الثلاثاء، 12 ديسمبر 2024',
          time: '11:30 صباحاً',
          location: 'عيادة العظام - الدور الثالث',
          price: '180 جنيه',
          status: 'upcoming',
          bookingNumber: '#12347',
        ),
      ],
    );
  }

  Widget _buildCompletedBookings() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildBookingCard(
          doctorName: 'د. أحمد محمود فتحي',
          specialty: 'استشاري الباطنة',
          date: 'الخميس، 5 ديسمبر 2024',
          time: '02:00 مساءً',
          location: 'عيادة الباطنة - الدور الأول',
          price: '130 جنيه',
          status: 'completed',
          bookingNumber: '#12340',
        ),
        Gap(12.h),
        _buildBookingCard(
          doctorName: 'د. نورا إبراهيم',
          specialty: 'استشاري الجلدية',
          date: 'الأربعاء، 29 نوفمبر 2024',
          time: '04:30 مساءً',
          location: 'عيادة الجلدية - الدور الثاني',
          price: '140 جنيه',
          status: 'completed',
          bookingNumber: '#12335',
        ),
      ],
    );
  }

  Widget _buildCancelledBookings() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildBookingCard(
          doctorName: 'د. عمر سعيد',
          specialty: 'استشاري الأنف والأذن',
          date: 'السبت، 2 ديسمبر 2024',
          time: '12:00 ظهراً',
          location: 'عيادة الأنف والأذن',
          price: '110 جنيه',
          status: 'cancelled',
          bookingNumber: '#12338',
          cancelReason: 'تم الإلغاء من قبل المريض',
        ),
      ],
    );
  }

  Widget _buildBookingCard({
    required String doctorName,
    required String specialty,
    required String date,
    required String time,
    required String location,
    required String price,
    required String status,
    required String bookingNumber,
    String? cancelReason,
  }) {
    Color statusColor;
    Color statusBgColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'upcoming':
        statusColor = ColorsManager.primaryColor;
        statusBgColor = ColorsManager.lightBlueBg;
        statusText = 'قادم';
        statusIcon = Icons.schedule;
        break;
      case 'completed':
        statusColor = ColorsManager.successGreen;
        statusBgColor = ColorsManager.successGreen.withOpacity(0.1);
        statusText = 'مكتمل';
        statusIcon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        statusColor = ColorsManager.errorRed;
        statusBgColor = ColorsManager.errorRed.withOpacity(0.1);
        statusText = 'ملغي';
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = ColorsManager.textGray;
        statusBgColor = ColorsManager.moreLighterGray;
        statusText = 'غير معروف';
        statusIcon = Icons.help_outline;
    }

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorsManager.borderGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryDark.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r),
              ),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 18.sp, color: statusColor),
                Gap(8.w),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                Text(
                  bookingNumber,
                  style: TextStyles.font12TextGrayMedium,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Info
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorsManager.primaryColor.withOpacity(0.1),
                            ColorsManager.primaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorsManager.lightBlueBorder,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 28.sp,
                        color: ColorsManager.primaryColor,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: TextStyles.font16PrimarySemiBold,
                          ),
                          Gap(4.h),
                          Text(
                            specialty,
                            style: TextStyles.font13TextGrayRegular,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Gap(16.h),
                Container(
                  height: 1,
                  color: ColorsManager.borderGray,
                ),
                Gap(16.h),

                // Booking Details
                _buildDetailRow(
                  Icons.calendar_today_outlined,
                  date,
                ),
                Gap(10.h),
                _buildDetailRow(
                  Icons.access_time_outlined,
                  time,
                ),
                Gap(10.h),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  location,
                ),
                Gap(10.h),
                _buildDetailRow(
                  Icons.payments_outlined,
                  price,
                ),

                if (cancelReason != null) ...[
                  Gap(16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.errorRed.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: ColorsManager.errorRed.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16.sp,
                          color: ColorsManager.errorRed,
                        ),
                        Gap(10.w),
                        Expanded(
                          child: Text(
                            cancelReason,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.errorRed,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Action Buttons
                if (status == 'upcoming') ...[
                  Gap(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showCancelDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: ColorsManager.errorRed.withOpacity(0.5),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            backgroundColor: ColorsManager.white,
                          ),
                          child: Text(
                            'إلغاء الحجز',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsManager.errorRed,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // إعادة جدولة الحجز
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                            shadowColor: ColorsManager.primaryColor.withOpacity(0.3),
                          ),
                          child: Text(
                            'إعادة جدولة',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsManager.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                if (status == 'completed') ...[
                  Gap(20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showRatingDialog(context);
                      },
                      icon: Icon(Icons.star_outline, size: 20.sp),
                      label: Text(
                        'تقييم الطبيب',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        foregroundColor: ColorsManager.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: ColorsManager.lightBlueBg,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 16.sp,
            color: ColorsManager.primaryColor,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Text(
            value,
            style: TextStyles.font13PrimaryDarkSemiBold,
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
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
                    Icons.warning_amber_rounded,
                    size: 32.sp,
                    color: ColorsManager.errorRed,
                  ),
                ),
                Gap(20.h),
                Text(
                  'إلغاء الحجز',
                  style: TextStyles.font18DarkBlueBold,
                ),
                Gap(12.h),
                Text(
                  'هل أنت متأكد من إلغاء هذا الحجز؟ سيتم إرسال إشعار للطبيب.',
                  textAlign: TextAlign.center,
                  style: TextStyles.font14GrayRegular,
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
                          'رجوع',
                          style: TextStyles.font14DarkBlueMedium,
                        ),
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: ColorsManager.white,
                                    size: 20.sp,
                                  ),
                                  Gap(12.w),
                                  const Text('تم إلغاء الحجز بنجاح'),
                                ],
                              ),
                              backgroundColor: ColorsManager.successGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              margin: EdgeInsets.all(16.w),
                            ),
                          );
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
                          'إلغاء الحجز',
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

  void _showRatingDialog(BuildContext context) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
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
                      color: ColorsManager.ratingYellow.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 32.sp,
                      color: ColorsManager.ratingYellow,
                    ),
                  ),
                  Gap(20.h),
                  Text(
                    'تقييم الطبيب',
                    style: TextStyles.font18DarkBlueBold,
                  ),
                  Gap(8.h),
                  Text(
                    'ساعدنا في تحسين خدماتنا',
                    style: TextStyles.font14GrayRegular,
                  ),
                  Gap(24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => rating = index + 1),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Icon(
                            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 36.sp,
                            color: ColorsManager.ratingYellow,
                          ),
                        ),
                      );
                    }),
                  ),
                  Gap(24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: rating > 0
                          ? () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: ColorsManager.white,
                                        size: 20.sp,
                                      ),
                                      Gap(12.w),
                                      const Text('شكراً لتقييمك!'),
                                    ],
                                  ),
                                  backgroundColor: ColorsManager.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  margin: EdgeInsets.all(16.w),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        disabledBackgroundColor: ColorsManager.lighterGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'إرسال التقييم',
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
            ),
          ),
        ),
      ),
    );
  }
}