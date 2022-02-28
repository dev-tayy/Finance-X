import 'package:finance_x/components/snackbar.dart';
import 'package:finance_x/core/services/navigation/navigation_service.dart';
import 'package:finance_x/features/transactions/views/add_debtors.dart';
import 'package:finance_x/features/transactions/views/add_expenses.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';

Future showAddTransactionBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Container(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
        decoration: const BoxDecoration(
          color: AppColors.greyShade7,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              TextButton(
                onPressed: () {
                  NavigationService.navigateTo(AddExpensesScreen.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.tertiaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.add_circle,
                            color: AppColors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Add expenses',
                          style:
                              TextStyle(fontSize: 17, color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              TextButton(
                onPressed: () {
                  NavigationService.navigateTo(AddDebtorsScreen.id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.textColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.add_circle,
                            color: AppColors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Add debtors',
                          style:
                              TextStyle(fontSize: 17, color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 20),
           
          ],
        ),
      );
    },
  );
}

Future showDebtorBottomSheet(
  BuildContext context, {
  required String debtorName,
  required int amount,
  required String phoneNumber,
  required DateTime borrowedDate,
  required DateTime dueDate,
  String? email,
  String? description,
}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Container(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
        decoration: const BoxDecoration(
          color: AppColors.greyShade7,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(debtorName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Text(description ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Owing:  N$amount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Text(
                'Borrowed on: ${DateFormat('MMMEd').format(borrowedDate)} - ${DateFormat('jm').format(borrowedDate)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
                'Due date: ${DateFormat('MMMEd').format(dueDate)} - ${DateFormat('jm').format(dueDate)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed: () async {
                  String subject = 'Debt Overdue';
                  String body =
                      '$debtorName\nYour debt has exceeded the due date.\nPlease pay up as soon as possible.\nRegards,\nAdmin.';
                  String emailUrl = "mailto:$email?subject=$subject&body=$body";

                  if (await canLaunch(emailUrl)) {
                    await launch(emailUrl);
                  } else {
                    FXSnackbar.showErrorSnackBar(context,
                        message: "Error occured trying to send an email.");
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.textColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.mail, color: AppColors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Remind debtor',
                          style:
                              TextStyle(fontSize: 17, color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      );
    },
  );
}
