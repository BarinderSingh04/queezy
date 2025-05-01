import 'package:get_it/get_it.dart';
import 'package:queezy/splash_and_onBoarding/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/nav_router.dart';
import 'package:queezy/service/queezy_service.dart';
import 'package:queezy/splash_and_onBoarding/cubit/quiz_state_cubit.dart';

import '../splash_and_onBoarding/cubit/create_quiz_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerFactory<NavRouter>(() => NavRouter());
  getIt.registerSingleton<QueezyService>(QueezyService());

  getIt.registerFactory<QueezyListCubit>(() => QueezyListCubit(getIt()));

  getIt.registerLazySingleton<QuizStateCubit>(() => QuizStateCubit());
  getIt.registerLazySingleton<CreateQuizCubit>(() => CreateQuizCubit());
}
