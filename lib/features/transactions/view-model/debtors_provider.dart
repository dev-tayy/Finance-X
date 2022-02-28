import 'package:finance_x/components/snackbar.dart';
import 'package:finance_x/core/api/api_result.dart';
import 'package:finance_x/core/api/result_state.dart';
import 'package:finance_x/core/models/user.dart';
import 'package:finance_x/core/services/database/firestore_db.dart';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/core/services/notification/notification_service.dart';
import 'package:finance_x/core/models/debtors.dart';
import 'package:finance_x/utils/fx_loader.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dbRepositoryProvider = Provider<DBService>((ref) => DBService());

final debtorsNotifierProvider = StateNotifierProvider((ref) => DebtorsNotifier(
      ref.watch(dbRepositoryProvider),
    ));

class DebtorsNotifier extends StateNotifier<ResultState> {
  DebtorsNotifier(this.dbService) : super(const ResultState.idle());

  final DBService dbService;

  Future<void> addDebtor({
    required String debtorName,
    required String debtorPhone,
    required int amount,
    required String description,
    required DateTime borrowedDate,
    required DateTime dueDate,
    String? debtorEmail,
    required BuildContext context,
  }) async {
    state = const ResultState.loading();
    FXLoader.show(context);

    Debtors debtor = Debtors(
      debtorName: debtorName,
      phoneNumber: debtorPhone,
      borrowedDateTime: borrowedDate,
      dueDateTime: dueDate,
      emailAddress: debtorEmail,
      amount: amount,
      description: description,
    );

    DBResultStatus _dbStatus = await dbService.addTransaction(
        fieldName: 'debtors', fieldValue: debtor.toJson()); //add debtor to db

    if (_dbStatus == DBResultStatus.success) {
      List<int> debts = [];

      ApiResult<User> dbResult =
          await dbService.getUserCredentials(); //get user credentials

      dbResult.when(
        success: (data) async {
          for (var data in data.debtors) {
            debts.add(data.amount); //get all debts amount
          }
          int totalDebts = debts.sum; //add all debts amount
          await dbService.updateUserCredentials(
              fieldName: 'totalDebts',
              fieldValue: totalDebts); //update total debts
        },
        failure: (error) {
          debugPrint(error.toString());
        },
      );

      NotificationService().scheduleNotifications(
          notificationTitle: '$debtorName Debt Due',
          notificationBody: 'Reminder to collect your money',
          dueDate: dueDate);

      FXLoader.hide();
      FXSnackbar.showSuccessSnackBar(context,
          message: 'Added successfully', milliseconds: 1500);
      NavigationService.goBack(context);
    } else {
      FXLoader.hide();
      FXSnackbar.showErrorSnackBar(context,
          message: 'Unable to add debtor', milliseconds: 3000);
    }
  }
}
