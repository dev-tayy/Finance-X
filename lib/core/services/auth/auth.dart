import 'package:finance_x/core/services/auth/auth_ex.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late AuthResultStatus _status;

  Future<AuthResultStatus> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      _status = AuthResultStatus.successful;
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> createAccount({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.currentUser!.updateDisplayName(fullName);
      _status = AuthResultStatus.successful;
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthResultStatus.successful)
        .catchError((e) => _status = AuthExceptionHandler.handleException(e));
    return _status;
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      _status = AuthResultStatus.successful;
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
  }

  static Future<bool> authenticateUserWithBiometrics() async {
    final LocalAuthentication _localAuthentication = LocalAuthentication();

    bool isAuthenticated = false;
    bool isBiometricSupported = await _localAuthentication.isDeviceSupported();
    bool isBiometricAvailable = await _localAuthentication.canCheckBiometrics;

    //if device supports biometrics, then authenticate.
    if (isBiometricSupported && isBiometricAvailable) {
      try {
        isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: 'Scan your fingerprint to continue',
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true);
      } on PlatformException catch (e) {
        debugPrint(e.toString());
      }
    }
    return isAuthenticated;
  }
}
