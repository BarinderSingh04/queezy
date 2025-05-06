import 'package:get_it/get_it.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/screens/cubit/avatar_list_cubit.dart';
import 'package:queezy/screens/cubit/create_room_cubit.dart';
import 'package:queezy/screens/cubit/join_room_cubit.dart';
import 'package:queezy/screens/cubit/leaderboard_cubit.dart';
import 'package:queezy/screens/cubit/player_scores_cubit.dart';
import 'package:queezy/screens/cubit/game_session_cubit.dart';
import 'package:queezy/routes/nav_router.dart';
import 'package:queezy/screens/cubit/quiz_room_cubit.dart';
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

  getIt.registerSingleton<LocalStorageService>(LocalStorageService(getIt.get<SharedPreferences>()));
  getIt.registerSingleton<TokenService>(TokenService());
  getIt.registerFactory<NavRouter>(() => NavRouter());
  getIt.registerSingleton<QueezyService>(QueezyService());
  getIt.registerSingleton<AuthService>(AuthService(getIt(), getIt()));

  getIt.registerLazySingleton<SocketService>(() => SocketService(getIt()));
  getIt.registerLazySingleton<GameSessionCubit>(() => GameSessionCubit(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<QuizLogicCubit>(() => QuizLogicCubit());
  getIt.registerLazySingleton<PlayerScoresCubit>(() => PlayerScoresCubit(getIt(), getIt()));

  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerFactory<AvatarListCubit>(() => AvatarListCubit(getIt()));
  getIt.registerFactory<CreateRoomCubit>(() => CreateRoomCubit(getIt()));
  getIt.registerFactory<JoinRoomCubit>(() => JoinRoomCubit(getIt()));
  getIt.registerFactory<QuizRoomBloc>(() => QuizRoomBloc(getIt()));
  getIt.registerFactory<LeaderBoardCubit>(() => LeaderBoardCubit(getIt()));
}
