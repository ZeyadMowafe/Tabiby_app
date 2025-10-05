import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/routing/app_router.dart';
import 'package:tabiby/tabiby_app.dart';
import 'config/configrations.dart';

import 'features/login/logic/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.initialize();
  await ScreenUtil.ensureScreenSize();
 

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppAuthCubit>(
          create: (_) => AppAuthCubit(),
        ),
      ],
      child: TabibyApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}