import 'package:finance_x/utils/constants.dart';
import 'package:flutter/material.dart';

class ContactsListTile extends StatelessWidget {
  const ContactsListTile({
    Key? key,
    required this.givenName,
    required this.displayName,
    this.email,
    this.phoneNumber,
  }) : super(key: key);

  final String? displayName;
  final String? givenName;
  final String? email;
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.textColor,
        ),
        child: const Icon(Icons.account_box, color: AppColors.white),
      ),
      contentPadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: 1,
            text: TextSpan(
              text: displayName,
              style: const TextStyle(
                  color: AppColors.black,
                  fontFamily: 'Karla',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            email ?? "",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF767474),
            ),
          ),
          Text(
            phoneNumber ?? "",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF767474),
            ),
          ),
        ],
      ),
    );
  }
}
