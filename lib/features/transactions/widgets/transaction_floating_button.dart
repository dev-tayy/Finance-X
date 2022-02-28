import 'package:finance_x/features/transactions/widgets/bottom_sheet.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:finance_x/utils/extensions.dart';
import 'package:flutter/material.dart';

class TransactionFloatingButton extends StatelessWidget {
  const TransactionFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showAddTransactionBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.add_circle,
              color: AppColors.white,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Add Transaction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ).paddingOnly(r: 10, b: 15),
    );
  }
}

