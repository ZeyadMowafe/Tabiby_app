// features/login/ui/widgets/login_form_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tabiby/features/login/logic/login_cubit.dart';
import 'package:tabiby/features/login/logic/login_state.dart';
import 'package:tabiby/features/login/ui/widgets/universal_field.dart';


import 'options_row.dart';
import 'login_button.dart';
import 'social_buttons.dart';
import 'divider_with_text.dart';

class LoginFormCard extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final bool obscurePassword;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onPasswordVisibilityChanged;
  final VoidCallback onLoginPressed;
  final VoidCallback onGoogleLoginPressed;
  final VoidCallback onAppleLoginPressed;

  const LoginFormCard({
    Key? key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.obscurePassword,
    required this.onRememberMeChanged,
    required this.onPasswordVisibilityChanged,
    required this.onLoginPressed,
    required this.onGoogleLoginPressed,
    required this.onAppleLoginPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E40AF).withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(28.w),
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;
              return _buildForm(isLoading, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isLoading, LoginState state) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // استخدام الحقل الموحد للبريد الإلكتروني
          UniversalField(
            controller: emailController,
            isLoading: isLoading,
            fieldType: FieldType.email,
            label: 'البريد الإلكتروني',
            hintText: 'example@email.com',
            prefixIcon: Icons.email_outlined,
          ),
          Gap(20.h),
          
          // استخدام الحقل الموحد لكلمة المرور
          UniversalField(
            controller: passwordController,
            isLoading: isLoading,
            fieldType: FieldType.password,
            label: 'كلمة المرور',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: obscurePassword,
            onVisibilityChanged: onPasswordVisibilityChanged,
          ),
          Gap(20.h),
          
          OptionsRow(
            rememberMe: rememberMe,
            isLoading: isLoading,
            onRememberMeChanged: onRememberMeChanged,
          ),
          Gap(32.h),
          
          LoginButton(
            isLoading: isLoading,
            state: state,
            onPressed: onLoginPressed,
          ),
          Gap(24.h),
          
          const DividerWithText(text: 'أو'),
          Gap(24.h),
          
          SocialButtons(
            isLoading: isLoading,
            state: state,
            onGooglePressed: onGoogleLoginPressed,
            onApplePressed: onAppleLoginPressed,
          ),
        ],
      ),
    );
  }
}