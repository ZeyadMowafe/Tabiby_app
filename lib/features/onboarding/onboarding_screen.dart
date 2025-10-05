import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theming/colors.dart';
import 'onboarding_data.dart';
import 'onboarding_page.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/onboarding_navigation.dart';
import '../login/ui/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Premium onboarding content
  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Expert Medical Care",
      subtitle: "At Your Fingertips",
      description: "Connect with board-certified specialists and experienced healthcare professionals across all medical disciplines with verified credentials and proven track records.",
      primaryIcon: Icons.medical_services_rounded,
      backgroundIcons: [Icons.health_and_safety_outlined, Icons.verified_user_outlined, Icons.local_hospital_outlined],
      color: ColorsManager.primaryBlue,
      stats: "10,000+ Doctors",
    ),
    OnboardingData(
      title: "Smart Scheduling",
      subtitle: "Book Instantly",
      description: "Advanced AI-powered booking system that finds the perfect appointment slot based on your preferences,",
      primaryIcon: Icons.event_available_rounded,
      backgroundIcons: [Icons.schedule_rounded, Icons.notifications_active_outlined, Icons.smartphone_rounded],
      color: ColorsManager.lightBlue,
      stats: "99% Success Rate",
    ),
    OnboardingData(
      title: "Seamless Experience",
      subtitle: "Real-time Updates",
      description: "Get instant confirmations, smart reminders, and real-time updates about your appointments. ",
      primaryIcon: Icons.timeline_rounded,
      backgroundIcons: [Icons.check_circle_outline_rounded, Icons.sync_rounded, Icons.integration_instructions_outlined],
      color: ColorsManager.darkBlue,
      stats: "24/7 Support",
    ),
    OnboardingData(
      title: "Premium Healthcare",
      subtitle: "Redefined",
      description: "Experience the future of healthcare with telemedicine options, digital prescriptions, health insights, ",
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
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  void _resetAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _scaleController.reset();
    _startAnimations();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
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
          _resetAnimations();
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: Listenable.merge([_fadeAnimation, _slideAnimation, _scaleAnimation]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: OnboardingPage(data: _pages[index]),
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