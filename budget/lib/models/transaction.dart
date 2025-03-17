import 'package:hive/hive.dart';

part 'transaction.g.dart'; 

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final double amount;
  
  @HiveField(2)
  final bool isIncome;
  
  @HiveField(3)
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}