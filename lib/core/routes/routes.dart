import 'package:finance_x/core/routes/page_route.dart';
import 'package:finance_x/features/auth/view/auth_biometric.dart';
import 'package:finance_x/features/auth/view/login_screen.dart';
import 'package:finance_x/features/auth/view/signup_screen.dart';
import 'package:finance_x/features/transactions/views/add_debtors.dart';
import 'package:finance_x/features/transactions/views/add_expenses.dart';
import 'package:finance_x/features/transactions/views/home.dart';
import 'package:finance_x/splash_screen.dart';
import 'package:flutter/material.dart';

class RMRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.id:
        return RMPageRoute(builder: (_) => const SplashScreen());

      case SignUpScreen.id:
        return RMPageRoute(builder: (_) => SignUpScreen());

      case LoginScreen.id:
        return RMPageRoute(builder: (_) => LoginScreen());

      case HomeScreen.id:
        dynamic args = settings.arguments;

        return RMPageRoute(
            builder: (_) => HomeScreen(
                  user: args['user'],
                ));

      case AddExpensesScreen.id:
        return RMPageRoute(builder: (_) => AddExpensesScreen());

      case AddDebtorsScreen.id:
        return RMPageRoute(builder: (_) => AddDebtorsScreen());

      case AuthBiometricsScreen.id:
        return RMPageRoute(builder: (_) => const AuthBiometricsScreen());

      default:
        return RMPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Something went wrong')),
                ));
    }
  }
}
