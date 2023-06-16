import 'dart:convert';

import 'package:budgplan/Home.dart';

final String tableFinance = 'financeData';

class financeFields {
  static final List<String> values = [id, amount, category, date];
  static final String id = '_id';
  static final String amount = 'amount';
  static final String category = 'category';
  static final String date = 'date';
  static final String reason = 'reason';
}

class Data {
  final int? id;
  final int amount;
  final String category;
  final String date;
  final String reason;

  const Data({
    required this.amount,
    this.id,
    required this.category,
    required this.date,
    required this.reason,
  });

  Data copy({
    int? id,
    int? amount,
    String? category,
    String? date,
    String? reason,
  }) =>
      Data(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        date: date ?? this.date,
        reason: reason ?? this.reason,
      );

  static Data fromJson(Map<String, Object?> json) => Data(
        id: json[financeFields.id] as int?,
        amount: json[financeFields.amount] as int,
        category: json[financeFields.category] as String,
        date: json[financeFields.date] as String,
        reason: json[financeFields.reason] as String,
      );

  Map<String, Object?> toJson() => {
        financeFields.id: id,
        financeFields.amount: amount,
        financeFields.category: category,
        financeFields.date: date,
        financeFields.reason: reason,
      };
}
