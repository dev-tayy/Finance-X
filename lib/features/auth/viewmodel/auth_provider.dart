import 'package:finance_x/components/snackbar.dart';
import 'package:finance_x/core/api/api_result.dart';
import 'package:finance_x/core/api/result_state.dart';
import 'package:finance_x/core/models/user.dart';
import 'package:finance_x/core/services/auth/auth.dart';
import 'package:finance_x/core/services/auth/auth_ex.dart';
import 'package:finance_x/core/services/database/firestore_db.dart';
import 'package:finance_x/core/services/database/local_storage.dart';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/features/auth/view/login_screen.dart';
import 'package:finance_x/features/transactions/views/home.dart';
import 'package:finance_x/utils/fx_loader.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider =
    Provider<AuthenticationService>((ref) => AuthenticationService());

final dbRepositoryProvider = Provider<DBService>((ref) => DBService());

final authNotifierProvider =
    StateNotifierProvider<AuthServiceNotifier, ResultState<User>>(
  (ref) => AuthServiceNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(dbRepositoryProvider),
  ),
);

class AuthServiceNotifier extends StateNotifier<ResultState<User>> {
  AuthServiceNotifier(this.authenticationService, this.dbService)
      : super(const ResultState.idle());
  final AuthenticationService authenticationService;
  final DBService dbService;

  //REGISTER NEW USERS
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    FXLoader.show(context);

    User user = User(
      fullName: fullName,
      emailAddress: email,
      phoneNumber: phoneNumber,
      totalDebts: 0,
      totalExpenses: 0,
      expenses: [],
      debtors: [],
    );

    AuthResultStatus _status = await authenticationService.createAccount(
        email: email, password: password, fullName: fullName);

    DBResultStatus _dbStatus = await dbService.uploadUserCredentials(user);

    if (_status == AuthResultStatus.successful) {
      if (_dbStatus == DBResultStatus.success) {
        FXLoader.hide();
        FXSnackbar.showSuccessSnackBar(context,
            message: 'Account created successfully! Log in to continue',
            milliseconds: 5000);
        NavigationService.navigateTo(LoginScreen.id);
      } else {
        FXLoader.hide();
        FXSnackbar.showErrorSnackBar(context,
            message: 'Unable to register user. Please try again later',
            milliseconds: 3000);
      }
    } else {
      FXLoader.hide();
      FXSnackbar.showErrorSnackBar(context,
          message: AuthExceptionHandler.generateExceptionMessage(_status),
          milliseconds: 3000);
    }
  }

  //LOGIN USERS
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FXLoader.show(context);

    AuthResultStatus _status =
        await authenticationService.logIn(email: email, password: password);

    if (_status == AuthResultStatus.successful) {
      ApiResult<User> _dbStatus = await dbService.getUserCredentials();
      _dbStatus.when(
        success: (data) {
          FXLoader.hide();
          SharedPrefs.setSignIn(true);
          SecureStorage.saveEmail(email);
          SecureStorage.savePasskey(password);
          NavigationService.navigatePushandPopUntil(HomeScreen.id,
              arguments: {'user': data});
        },
        failure: (error) {
          FXLoader.hide();
          FXSnackbar.showErrorSnackBar(context,
              message: 'Unable to login user. Please try again later',
              milliseconds: 3000);
        },
      );
    } else {
      FXLoader.hide();
      FXSnackbar.showErrorSnackBar(context,
          message: AuthExceptionHandler.generateExceptionMessage(_status),
          milliseconds: 3500);
    }
  }

  //LOGIN USERS WITH BIOMETRICS
  Future<void> loginWithBiometrics(BuildContext context) async {
    FXLoader.show(context);
    late bool hasSignedIn;
    late String email;
    late String password;

    await SharedPrefs.getSignIn().then((value) async {
      if (value != null) {
        hasSignedIn = value;
        if (hasSignedIn) {
          bool isAuthenticated =
              await AuthenticationService.authenticateUserWithBiometrics();

          if (isAuthenticated) {
            await SecureStorage.getEmail().then((value) async {
              if (value != null) {
                email = value;
                await SecureStorage.getPasskey().then((value) async {
                  if (value != null) {
                    password = value;
                    AuthResultStatus _status = await authenticationService
                        .logIn(email: email, password: password);

                    if (_status == AuthResultStatus.successful) {
                      ApiResult<User> _dbStatus =
                          await dbService.getUserCredentials();
                      _dbStatus.when(
                        success: (data) {
                          FXLoader.hide();
                          SharedPrefs.setSignIn(true);
                          NavigationService.navigatePushandPopUntil(
                              HomeScreen.id,
                              arguments: {'user': data});
                        },
                        failure: (error) {
                          FXLoader.hide();
                          FXSnackbar.showErrorSnackBar(context,
                              message:
                                  'Unable to login user. Please try again later',
                              milliseconds: 3000);
                        },
                      );
                    } else {
                      FXLoader.hide();
                      FXSnackbar.showErrorSnackBar(context,
                          message:
                              AuthExceptionHandler.generateExceptionMessage(
                                  _status),
                          milliseconds: 3500);
                    }
                  }
                });
              } else {
                FXLoader.hide();
                FXSnackbar.showErrorSnackBar(context,
                    message:
                        'Log in with email and password to activate biometrics',
                    milliseconds: 350);
              }
            });
          } else {
            FXLoader.hide();
            FXSnackbar.showErrorSnackBar(context,
                message: 'Error authenticating user with biometrics',
                milliseconds: 350);
          }
        } else {
          FXLoader.hide();
          FXSnackbar.showErrorSnackBar(context,
              message: 'Log in with email and password to activate biometrics',
              milliseconds: 350);
        }
      } else {
        FXLoader.hide();
        FXSnackbar.showErrorSnackBar(context,
            message: 'Log in with email and password to activate biometrics',
            milliseconds: 350);
      }
    });
  }

  //LOGOUT USERS
  Future<void> logout(BuildContext context) async {
    FXLoader.show(context);
    await authenticationService.logout().then((value) async {
      FXLoader.hide();
      SharedPrefs.setSignIn(false);
      SecureStorage.dispose();
      NavigationService.navigatePushandPopUntil(LoginScreen.id);
    });
  }
}
