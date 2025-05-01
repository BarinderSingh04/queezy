import 'package:get_it/get_it.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/screens/cubit/player_scores_cubit.dart';
import 'package:queezy/screens/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/nav_router.dart';
import 'package:queezy/screens/service/auth_service.dart';
import 'package:queezy/screens/service/queezy_service.dart';
import 'package:queezy/screens/cubit/quiz_logic_cubit.dart';
import 'package:queezy/service/socket_service.dart';
import 'package:queezy/service/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/local_storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingletonAsync(() async => SharedPreferences.getInstance());
  await getIt.isReady<SharedPreferences>();

  ///RepositoryProviders
  getIt.registerSingleton<LocalStorageService>(
      LocalStorageService(getIt.get<SharedPreferences>()));
  getIt.registerSingleton<TokenService>(TokenService());
  getIt.registerFactory<NavRouter>(() => NavRouter());
  getIt.registerSingleton<QueezyService>(QueezyService());
  getIt.registerSingleton<AuthService>(AuthService(getIt(),getIt()));
  getIt.registerLazySingleton<SocketService>(() => SocketService(getIt()));

  getIt.registerLazySingleton<QueezyListCubit>(() => QueezyListCubit(getIt()));
  getIt.registerLazySingleton<QuizLogicCubit>(() => QuizLogicCubit());
  getIt.registerLazySingleton<PlayerScoresCubit>(
    () => PlayerScoresCubit(getIt()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
}
