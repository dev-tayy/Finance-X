class Expenses {
  Expenses({
    required this.amount,
    required this.category,
    required this.dateTime,
    this.description,
  });

  int amount;
  String? description;
  String category;
  DateTime dateTime;

  factory Expenses.fromJson(Map<String, dynamic> json) => Expenses(
        amount: json["amount"],
        category: json["category"],
        dateTime: DateTime.parse(json["dateTime"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "category": category,
        "dateTime": dateTime.toIso8601String(),
        "description": description,
      };
}
