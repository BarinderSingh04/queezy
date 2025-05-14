import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queezy/di/service_locator.dart';
import 'package:queezy/routes/nav_router.dart';
import 'package:queezy/screens/cubit/auth_cubit.dart';
import 'package:queezy/theme/cubit/theme_cubit.dart';

import 'common/observer.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = GlobalBlocObserver();
  await setupServiceLocator();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => BlocProvider(create: (context) => ThemeCubit(), child: const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appRoute = getIt<NavRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (contex, state) {
          return BlocListener<AuthCubit, AuthenticationState>(
            listenWhen: (previous, current) {
              return current is AuthenticatedState || current is UnAuthenticatedState;
            },
            listener: (context, state) {
              appRoute.router.refresh();
            },
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                DevicePreview.appBuilder;
                final mediaQueryData = MediaQuery.of(context);
                return MediaQuery(
                  data: mediaQueryData.copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
              locale: DevicePreview.locale(context),
              title: 'Flutter Demo',
              theme: AppTheme().lightTheme,
              themeMode: state,
              routerConfig: appRoute.router,
            ),
          );
        },
      ),
    );
  }
}
