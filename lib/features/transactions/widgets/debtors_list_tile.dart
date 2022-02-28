import 'package:finance_x/features/transactions/widgets/bottom_sheet.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DebtorsListTile extends StatelessWidget {
  const DebtorsListTile({
    Key? key,
    required this.amount,
    required this.debtorName,
    required this.debtorPhone,
    required this.borrowedDate,
    required this.dueDate,
    this.description,
    this.debtorEmail,
  }) : super(key: key);

  final int amount;
  final String debtorName;
  final String? debtorEmail;
  final String debtorPhone;
  final String? description;
  final DateTime borrowedDate;
  final DateTime dueDate;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await showDebtorBottomSheet(context,
            amount: amount,
            borrowedDate: borrowedDate,
            dueDate: dueDate,
            debtorName: debtorName,
            phoneNumber: debtorPhone,
            description: description,
            email: debtorEmail);
      },
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.tertiaryColor),
          child: const Icon(Icons.show_chart, color: AppColors.white),
        ),
        contentPadding: EdgeInsets.zero,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textScaleFactor: 1,
              text: TextSpan(
                text: '$debtorName - ',
                style: const TextStyle(
                    color: AppColors.black,
                    fontFamily: 'Karla',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      color: AppColors.greyShade1,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Borrowed on: ${DateFormat('MMMEd').format(borrowedDate)} - ${DateFormat('jm').format(borrowedDate)}\nDue date: ${DateFormat('MMMEd').format(dueDate)} - ${DateFormat('jm').format(dueDate)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF767474),
              ),
            )
          ],
        ),
        trailing: Text(
            amount.toStringAsFixed(2).replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},'),
            style: const TextStyle(
                color: AppColors.tertiaryColor,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
