class Debtors {
  Debtors({
    required this.amount,
    required this.debtorName,
    required this.phoneNumber,
    required this.borrowedDateTime,
    required this.dueDateTime,
    this.emailAddress,
    required this.description,
  });

  int amount;
  String debtorName;
  String description;
  String phoneNumber;
  String? emailAddress;
  DateTime borrowedDateTime;
  DateTime dueDateTime;

  factory Debtors.fromJson(Map<String, dynamic> json) => Debtors(
        amount: json["amount"],
        debtorName: json["debtorName"],
        phoneNumber: json["phoneNumber"],
        borrowedDateTime: DateTime.parse(json["borrowedDateTime"]),
        dueDateTime: DateTime.parse(json["dueDateTime"]),
        emailAddress: json["emailAddress"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "debtorName": debtorName,
        "phoneNumber": phoneNumber,
        "borrowedDateTime": borrowedDateTime.toIso8601String(),
        "dueDateTime": dueDateTime.toIso8601String(),
        "emailAddress": emailAddress,
        "description": description,
      };
}
