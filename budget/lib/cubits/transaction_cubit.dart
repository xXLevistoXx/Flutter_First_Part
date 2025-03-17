import 'package:budget/models/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class TransactionState {
  final List<Transaction> transactions;
  final String filter; 

  TransactionState({
    required this.transactions,
    this.filter = 'все',
  });

  double get balance => transactions.fold(
    0.0,
    (sum, item) => sum + (item.isIncome ? item.amount : -item.amount),
  );
}

class TransactionCubit extends Cubit<TransactionState> {
  final Box<Transaction> transactionBox;

  TransactionCubit(this.transactionBox)
      : super(TransactionState(transactions: transactionBox.values.toList()));

  void addTransaction(String title, double amount, bool isIncome) {
    final transaction = Transaction(
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: DateTime.now(),
    );
    transactionBox.add(transaction);
    emit(TransactionState(
      transactions: transactionBox.values.toList(),
      filter: state.filter,
    ));
  }

  void setFilter(String filter) {
    emit(TransactionState(
      transactions: transactionBox.values.toList(),
      filter: filter,
    ));
  }
}