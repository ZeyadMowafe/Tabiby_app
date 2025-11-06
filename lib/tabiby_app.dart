import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';

import 'core/theming/colors.dart';

class TabibyApp extends StatefulWidget {
  final AppRouter appRouter;
  const TabibyApp({super.key, required this.appRouter});

  @override
  State<TabibyApp> createState() => _TabibyAppState();
}

class _TabibyAppState extends State<TabibyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // تم إزالة تهيئة الـ deep linking
  }

  void _showErrorSnackBar(String message) {
    final context = _navigatorKey.currentContext;
    if (context != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Tabiby',
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.onBoardingScreen,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }
}
