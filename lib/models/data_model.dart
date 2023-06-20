final String tableFinance = 'financeData';
final String tableUser = 'userData';

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

// user data model
class userFields {
  static final List<String> values = [id, balance, name];
  static final String id = '_id';
  static final String balance = 'balance';
  static final String name = 'name';
  static final String phonenumber = 'phonenumber';
}

class UserData {
  final int? id;
  final int? balance;
  final String name;
  final int phonenumber;

  const UserData({
    this.balance,
    this.id,
    required this.name,
    required this.phonenumber,
  });

  UserData copy({
    int? id,
    int? balance,
    String? name,
    int? phonenumber,
  }) =>
      UserData(
        id: id ?? this.id,
        balance: balance ?? this.balance,
        name: name ?? this.name,
        phonenumber: phonenumber ?? this.phonenumber,
      );

  static UserData fromJson(Map<String, Object?> json) => UserData(
        id: json[userFields.id] as int?,
        balance: json[userFields.balance] as int,
        name: json[userFields.name] as String,
        phonenumber: json[userFields.phonenumber] as int,
      );

  Map<String, Object?> toJson() => {
        userFields.id: id,
        userFields.balance: balance,
        userFields.name: name,
        userFields.phonenumber: phonenumber,
      };
}
