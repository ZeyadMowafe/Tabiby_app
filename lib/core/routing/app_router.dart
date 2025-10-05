import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/routing/routes.dart';
import 'package:tabiby/features/home/ui/patient_home_screen.dart';
import 'package:tabiby/features/login/ui/OTP_screen.dart';
import 'package:tabiby/features/login/ui/reset_password_OTP.dart';


import '../../features/login/logic/auth_cubit.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/login/ui/sign_up_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/login/ui/email_verification_screen.dart';
import '../../features/login/ui/forget_password_screen.dart';
import '../../features/login/logic/auth_state.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit(),
            child: const LoginScreen(),
          ),
        );

      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit(),
            child: const SignUpScreen(),
          ),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit()..checkAuthStatus(),
            child: const PatientHomeScreen(),
          ),
        );

      case Routes.emailVerificationScreen:
        final args = arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit(),
            child: EmailVerificationScreen(
              email: args?['email'] ?? '',
              message: args?['message'] ?? '',
            ),
          ),
        );

      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit(),
            child: const ForgotPasswordScreen(),
          ),
        );

      // New OTP-based reset password screen
      case Routes.resetPasswordWithOTPScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit(),
            child: const ResetPasswordWithOTPScreen(),
          ),
        );

      // OTP Input Screen
      case Routes.otpInputScreen:
        final args = arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        final otpType = args?['otpType'] as OTPType? ?? OTPType.emailVerification;
        final message = args?['message'] as String?;
        final newPassword = args?['newPassword'] as String?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppAuthCubit(),
            child: OTPInputScreen(
              email: email,
              otpType: otpType,
              message: message,
              newPassword: newPassword,
            ),
          ),
        );

      // Keep the old reset password screen for backward compatibility
      case Routes.resetPasswordScreen:
        final args = arguments as Map<String, dynamic>?;
        final accessToken = args?['accessToken'] as String?;
        
        print('Router: Handling reset password with token: ${accessToken?.substring(0, 10) ?? 'null'}...');
        
        if (accessToken == null || accessToken.isEmpty) {
          print('No token provided, redirecting to OTP-based reset');
          // Redirect to OTP-based reset password screen
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => AppAuthCubit(),
              child: const ResetPasswordWithOTPScreen(),
            ),
          );
        }

        

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                "No route defined for ${settings.name}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
    }
  }
}