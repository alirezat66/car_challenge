import 'package:car_challenge/core/di/service_locator.dart';
import 'package:car_challenge/core/route/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator().setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CarOnSale Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0ABAB5)),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
