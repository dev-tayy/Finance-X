import 'package:finance_x/core/routes/routes.dart';
import 'package:finance_x/core/services/app_lifecycle_manager.dart';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/core/services/notification/notification_service.dart';
import 'package:finance_x/splash_screen.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();  //initialize notification service
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.black,
  ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance-X',
        navigatorKey: NavigationService.navigationKey,
        theme: ThemeData(
          fontFamily: 'Karla',
          primarySwatch: Colors.blue,
        ),
        initialRoute: SplashScreen.id,
        onGenerateRoute: RMRouter.generateRoute,
      ),
    );
  }
}
