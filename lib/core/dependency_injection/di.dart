import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/supervisor_register/presentation/manager/supervisor_register_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  /// Cubits -> useCases -> Repos -> Services

  /// <------ SUPERVISOR REGISTER ------->
  di.registerFactory(() => SupervisorRegisterCubit());

  // di.registerFactory(() => LoginCubit(loginUseCase: di()));
  // di.registerLazySingleton(() => LoginUseCase(loginRepo: di()));
  // di.registerLazySingleton<LoginRepo>(() => LoginRepoImpl(loginService: di()));
  // di.registerLazySingleton<LoginService>(() => LoginServiceImpl());



  /// external
  final sharedPrefs = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPrefs);
}
