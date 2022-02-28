import 'package:finance_x/core/models/user.dart';
import 'package:finance_x/features/auth/viewmodel/auth_provider.dart';
import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardTopContainer extends HookConsumerWidget {
  const DashboardTopContainer({
    Key? key,
    required this.user,
    required this.size,
  }) : super(key: key);

  final Size size;
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size.width,
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: AppColors.black,
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(0, 10),
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hello, ${user.fullName}',
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                        ref.read(authNotifierProvider.notifier).logout(context);
                    },
                    child: const Text('Logout',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 100,
          left: 50,
          right: 50,
          child: Container(
            width: size.width * 0.6,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.grey,
                  offset: Offset(0, 5),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Expenses',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 5),
                    Text('N ${user.totalExpenses?.ceilToDouble()}',
                        style: const TextStyle(
                            color: AppColors.tertiaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const Expanded(
                    child: SizedBox(width: 10, child: VerticalDivider())),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Debts',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 5),
                    Text('N ${user.totalDebts?.ceilToDouble()}',
                        style: const TextStyle(
                            color: AppColors.tertiaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
