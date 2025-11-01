import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'onboarding_data.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 
                      MediaQuery.of(context).padding.top - 
                      MediaQuery.of(context).padding.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildIllustration(),
                SizedBox(height: 40.h),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 260.w,
          height: 260.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ..._buildBackgroundCircles(),
              ..._buildFloatingIcons(),
              _buildMainIcon(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return List.generate(3, (index) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 1000 + (index * 200)),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Container(
            width: (280 - (index * 40.0)) * value,
            height: (280 - (index * 40.0)) * value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.data.color.withOpacity(0.05 - (index * 0.01)),
              border: Border.all(
                color: widget.data.color.withOpacity(0.1),
                width: 1,
              ),
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildFloatingIcons() {
    return widget.data.backgroundIcons.asMap().entries.map((entry) {
      int idx = entry.key;
      IconData icon = entry.value;
      double radius = 100;

      double angle = (idx * 120) * (3.14159 / 180);
      double xPosition = 160 + (radius * (idx == 0 ? 1 : idx == 1 ? -0.5 : -0.5));
      double yPosition = 160 + (radius * (idx == 0 ? 0 : idx == 1 ? 0.866 : -0.866));

      return Positioned(
        left: xPosition - 24,
        top: yPosition - 24,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 800 + (idx * 150)),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.data.color.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: widget.data.color,
                  size: 24,
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  Widget _buildMainIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.data.color,
                  widget.data.color.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.data.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              widget.data.primaryIcon,
              color: Colors.white,
              size: 42,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildStatsBadge(),
            SizedBox(height: 24.h),
            _buildTitle(),
            SizedBox(height: 12.h),
            _buildSubtitle(),
            SizedBox(height: 20.h),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: widget.data.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: widget.data.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        widget.data.stats,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: widget.data.color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.data.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF0A1628),
        height: 1.2,
        letterSpacing: -0.8,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      widget.data.subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: widget.data.color,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        widget.data.description ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFF64748B),
          height: 1.6,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}