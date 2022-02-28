import 'package:finance_x/core/models/debtors.dart';
import 'package:finance_x/core/models/expenses.dart';

class User {
  User({
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.expenses,
    required this.debtors,
    this.totalDebts,
    this.totalExpenses,
  });

  String fullName;
  String phoneNumber;
  String emailAddress;
  List<Expenses> expenses;
  List<Debtors> debtors;
  int? totalExpenses;
  int? totalDebts;

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        emailAddress: json["emailAddress"],
        expenses: List<Expenses>.from(
            json["expenses"].map((x) => Expenses.fromJson(x))),
        debtors: List<Debtors>.from(
            json["debtors"].map((x) => Debtors.fromJson(x))),
        totalDebts: json["totalDebts"],
        totalExpenses: json["totalExpenses"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "emailAddress": emailAddress,
        "expenses": List<Expenses>.from(expenses.map((x) => x.toJson())),
        "debtors": List<Debtors>.from(debtors.map((x) => x.toJson())),
        "totalDebts": totalDebts,
        "totalExpenses": totalExpenses,
      };
}
