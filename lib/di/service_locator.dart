import 'package:get_it/get_it.dart';
import 'package:queezy/splash_and_onBoarding/cubit/queezy_list_cubit.dart';
import 'package:queezy/routes/nav_router.dart';
import 'package:queezy/service/queezy_service.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerFactory<NavRouter>(() => NavRouter());
  getIt.registerSingleton<QueezyService>(QueezyService());

  getIt.registerLazySingleton<QueezyListCubit>(() => QueezyListCubit(getIt()));
}