import 'dart:async';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/features/auth/view/auth_biometric.dart';
import 'package:finance_x/features/auth/view/login_screen.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = "splash_screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2), () async {
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      await secureStorage.containsKey(key: 'emailKey').then((value) {
        if (!value) {
          NavigationService.navigateToReplace(LoginScreen.id);
        } else {
          NavigationService.navigateToReplace(AuthBiometricsScreen.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return const Scaffold(
        backgroundColor: AppColors.black,
        body: Center(
          child: Text(
            'Finance X',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
