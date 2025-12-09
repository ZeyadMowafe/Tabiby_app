import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/core/theming/styles.dart';
import 'package:tabiby/features/onboarding/ui/widgets/get_start_buttom.dart';
import 'package:tabiby/features/onboarding/ui/widgets/tabiby_image_and_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;
  late Animation<double> _logoAnimation;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Content animation controller
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Logo fade and scale animation
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );

    // Image slide animation
    _imageAnimation = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    // Text fade animation
    _textAnimation = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );

    // Button animation
    _buttonAnimation = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    // Start animations sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    await _logoController.forward();
    // Wait a bit
    await Future.delayed(const Duration(milliseconds: 300));
    // Start content animation
    await _contentController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Animated Doctor Image
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(_imageAnimation),
                child: FadeTransition(
                  opacity: _imageAnimation,
                  child: const DoctorImageAndText(),
                ),
              ),

              // Animated Text and Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    // Animated description text
                    FadeTransition(
                      opacity: _textAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(_textAnimation),
                        child: Text(
                          'طبيبي هو رفيقك في رحلتك الصحية.من حجز زياراتك الطبية إلى تنظيم مواعيدك بضغطة واحدة، بنسهّل عليك كل خطوة.لأن راحتك وصحتك دايمًا أولويتنا.',
                          style: TextStyles.font13GrayRegular,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Gap(30.h),

                    // Animated button
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0)
                          .animate(_buttonAnimation),
                      child: FadeTransition(
                        opacity: _buttonAnimation,
                        child: const GetStartedButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}