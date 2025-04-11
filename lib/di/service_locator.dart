import 'package:get_it/get_it.dart';
import 'package:queezy/routes/nav_router.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerFactory<NavRouter>(() => NavRouter());
}