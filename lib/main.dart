import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabiby/core/config/configrations.dart';
import 'package:tabiby/core/di/dependency_injection.dart';
import 'package:tabiby/core/routing/app_router.dart';
import 'package:tabiby/tabiby_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await SupabaseConfig.initialize();
  setupGetIt();
  await ScreenUtil.ensureScreenSize();
  // await checkIfLoggedInUser();
  runApp(TabibyApp(appRouter: AppRouter(),
    
  ));
}

// checkIfLoggedInUser() async {
//   String? userToken =
//   await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
//   if (!userToken.isNullOrEmpty()) {
//     isLoggedInUser = true;
//   } else {
//     isLoggedInUser = false;
//   }
// }