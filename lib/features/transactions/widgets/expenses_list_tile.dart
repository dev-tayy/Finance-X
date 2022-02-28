import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesListTile extends StatelessWidget {
  const ExpensesListTile({
    Key? key,
    required this.amount,
    required this.category,
    this.description,
    required this.timeStamp,
  }) : super(key: key);

  final String category;
  final String? description;
  final int amount;
  final DateTime timeStamp;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
              text: '$category - ',
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
            '${DateFormat('MMMEd').format(timeStamp)} - ${DateFormat('jm').format(timeStamp)}',
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
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
          style: const TextStyle(
              color: AppColors.tertiaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold)),
    );
  }
}
