import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theming/colors.dart';
import 'onboarding_data.dart';
import 'onboarding_page.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_navigation.dart';
import '../auth/ui/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  double _currentPageValue = 0.0;
  late AnimationController _contentAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Premium onboarding content
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Expert Medical Care",
      subtitle: "At Your Fingertips",
      // description: "Connect with board-certified specialists and experienced healthcare professionals across all medical",
      primaryIcon: Icons.medical_services_rounded,
      backgroundIcons: [Icons.health_and_safety_outlined, Icons.verified_user_outlined, Icons.local_hospital_outlined],
      color: ColorsManager.primaryBlue,
      stats: "10,000+ Doctors",
    ),
    OnboardingData(
      title: "Smart Scheduling",
      subtitle: "Book Instantly",
      // description: "Advanced AI-powered booking system that finds the perfect appointment slot based on your preferences.",
      primaryIcon: Icons.event_available_rounded,
      backgroundIcons: [Icons.schedule_rounded, Icons.notifications_active_outlined, Icons.smartphone_rounded],
      color: ColorsManager.lightBlue,
      stats: "99% Success Rate",
    ),
    OnboardingData(
      title: "Seamless Experience",
      subtitle: "Real-time Updates",
      // description: "Get instant confirmations, smart reminders, and real-time updates about your appointments.",
      primaryIcon: Icons.timeline_rounded,
      backgroundIcons: [Icons.check_circle_outline_rounded, Icons.sync_rounded, Icons.integration_instructions_outlined],
      color: ColorsManager.darkBlue,
      stats: "24/7 Support",
    ),
    OnboardingData(
      title: "Premium Healthcare",
      subtitle: "Redefined",
      // description: "Experience the future of healthcare with telemedicine options, digital prescriptions, and health insights.",
      primaryIcon: Icons.psychology_rounded,
      backgroundIcons: [Icons.favorite_outline_rounded, Icons.insights_rounded, Icons.security_rounded],
      color: ColorsManager.accentBlue,
      stats: "95% Satisfaction",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0.0;
      });
    });
    _initAnimations();
    _setSystemUIOverlayStyle();
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _initAnimations() {
    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _contentAnimationController.forward(from: 0.0);
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeIn),
          );

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.surfaceBlue,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(
              currentIndex: _currentIndex,
              totalPages: _pages.length,
              onSkipPressed: _skipToEnd,
            ),
            _buildPageView(),
            OnboardingNavigation(
              currentIndex: _currentIndex,
              totalPages: _pages.length,
              primaryColor: _pages[_currentIndex].color,
              onNextPressed: _nextPage,
              onPreviousPressed: _previousPage,
            ),
          ],
        ),
      ),
    );
  }

Widget _buildPageView() {
  return Expanded(
    child: PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
        _startAnimation();
      },
      itemCount: _pages.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        // Parallax effect calculation
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = (_currentPageValue - index).abs().clamp(0.0, 1.0);
        }

        // Only apply parallax to non-current pages
        final isCurrentPage = index == _currentIndex;
        final scale = isCurrentPage ? 1.0 : 1.0 - (value * 0.05);
        final opacity = isCurrentPage ? 1.0 : 1.0 - (value * 0.5);

        return AnimatedBuilder(
          animation: _contentAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: OnboardingPage(data: _pages[index]),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
} 