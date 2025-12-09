import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/routing/app_router.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/core/theming/color_manager.dart';

class TabibyApp extends StatelessWidget {
  final AppRouter appRouter;

  const TabibyApp({super.key, required this.appRouter});


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          title: 'Tabiby',
          theme: ThemeData(
            fontFamily: 'Tajawal',
            primaryColor: ColorsManager.mainBlue,
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.onBoardingScreen, //isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
          onGenerateRoute: appRouter.generateRoute,
        ));
  }
}