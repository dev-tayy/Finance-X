import 'package:finance_x/components/snackbar.dart';
import 'package:finance_x/core/api/api_result.dart';
import 'package:finance_x/core/api/result_state.dart';
import 'package:finance_x/core/models/user.dart';
import 'package:finance_x/core/services/database/firestore_db.dart';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/core/models/expenses.dart';
import 'package:finance_x/utils/fx_loader.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dbRepositoryProvider = Provider<DBService>((ref) => DBService());

final expensesNotifierProvider = StateNotifierProvider((ref) => ExpensesNotifer(
      ref.watch(dbRepositoryProvider),
    ));

class ExpensesNotifer extends StateNotifier<ResultState> {
  ExpensesNotifer(this.dbService) : super(const ResultState.idle());

  final DBService dbService;

  Future<void> addExpense({
    required int amount,
    required String description,
    required String category,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    FXLoader.show(context);

    Expenses expense = Expenses(
      amount: amount,
      description: description,
      category: category,
      dateTime: dateTime,
    );

    DBResultStatus _dbStatus = await dbService.addTransaction(
        fieldName: 'expenses', fieldValue: expense.toJson());

    if (_dbStatus == DBResultStatus.success) {
      List<int> expensesAmount = [];

      ApiResult<User> dbResult =
          await dbService.getUserCredentials(); //get user credentials

      dbResult.when(
        success: (data) async {
          for (var data in data.expenses) {
            expensesAmount.add(data.amount); //get all expenses amount
          }
          int totalExpenses = expensesAmount.sum; //add all expenses amount
          await dbService.updateUserCredentials(
              fieldName: 'totalExpenses',
              fieldValue: totalExpenses); //update user total expenses
        },
        failure: (error) {
          debugPrint(error.toString());
        },
      );

      FXLoader.hide();
      FXSnackbar.showSuccessSnackBar(context,
          message: 'Added successfully', milliseconds: 1500);
      NavigationService.goBack(context);
    } else {
      FXLoader.hide();
      FXSnackbar.showErrorSnackBar(context,
          message: 'Unable to add expense', milliseconds: 3000);
    }
  }
}
