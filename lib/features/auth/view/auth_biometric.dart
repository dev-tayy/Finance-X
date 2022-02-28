import 'package:finance_x/features/auth/viewmodel/auth_provider.dart';
import 'package:finance_x/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthBiometricsScreen extends HookConsumerWidget {
  static const String id = 'auth_biometrics_screen';
  const AuthBiometricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
                'To gain access to your account, tap the icon and scan your fingerprints.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 10),
          GestureDetector(
              onTap: () {
                ref
                    .read(authNotifierProvider.notifier)
                    .loginWithBiometrics(context);
              },
              child: const Icon(Icons.fingerprint, size: 100))
        ],
      ).paddingSymmetric(h: 20)),
    );
  }
}
