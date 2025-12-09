import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabiby/core/networking/supabase_server.dart';
import 'package:tabiby/features/login/data/repo/login_repo.dart';
import 'package:tabiby/features/login/logic/login_cubit.dart';
import 'package:tabiby/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:tabiby/features/sign_up/logic/sign_up_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ========== Supabase ==========
  getIt.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // ========== SupabaseService ==========
  getIt.registerLazySingleton<SupabaseService>(
    () => SupabaseService(),
  );

  // ========== Repositories ==========
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepository(getIt<SupabaseService>()),
  );

  // ========== Cubits ==========
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginRepository>()),
  );
   // ========== Repositories ==========
  getIt.registerLazySingleton<SignupRepository>(
    () => SignupRepository(getIt<SupabaseService>()),
  );

  // ========== Cubits ==========
  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<SignupRepository>()),
  );
}
