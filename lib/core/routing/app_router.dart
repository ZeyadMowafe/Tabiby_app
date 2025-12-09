import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/di/dependency_injection.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/features/login/logic/login_cubit.dart';
import 'package:tabiby/features/login/ui/forget_password.dart';
import 'package:tabiby/features/login/ui/login_screen.dart';
import 'package:tabiby/features/onboarding/ui/onboarding_view.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_cubit.dart';
import 'package:tabiby/features/sign_up/ui/OTP_verification_screen.dart';
import 'package:tabiby/features/sign_up/ui/sign_up_screen.dart';
import 'package:tabiby/features/home/home_screen.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {

    final arguments = settings.arguments;

    switch (settings.name) {

      // ----------------------
      // 🌟 Onboarding Screen
      // ----------------------
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      // ----------------------
      // 🌟 Login Screen
      // ----------------------
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      // ----------------------
      // 🌟 Sign Up Screen
      // ----------------------
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<SignupCubit>(),
            child: const SignUpScreen(),
          ),
        );

      // ----------------------
      // 🌟 OTP Verification Screen
      // ----------------------
      case Routes.otpScreen:

        // 1) تحقق الآمان: لازم arguments يكون String (الإيميل)
        if (arguments is! String) {
          return _errorRoute("OTP Screen requires an email (String).");
        }

        final email = arguments;

        // 2) بنستخدم نفس Cubit بتاع signup (مش بنعمل Cubit جديد)
        final signupCubit = getIt<SignupCubit>();

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: signupCubit,
            child: OTPVerificationScreen(email: email),
          ),
        );

      // ----------------------
      // 🌟 Forget Password Screen
      // ----------------------
      case Routes.forgetPasswordScreen:
        final loginCubit = getIt<LoginCubit>();

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: loginCubit,
            child: const ForgetPasswordScreen(),
          ),
        );

      // ----------------------
      // 🌟 Home Screen
      // ----------------------
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      // ----------------------
      // 🌟 Unknown Route (404)
      // ----------------------
      default:
        return _errorRoute("No route found for: ${settings.name}");
    }
  }

  // ***********************
  // 🌟 Error Screen (آمنة)
  // ***********************
  Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Routing Error")),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
