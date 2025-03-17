import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/transaction.dart';
import 'cubits/transaction_cubit.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  final box = await Hive.openBox<Transaction>('transactions');
  
  runApp(MyApp(box));
}

class MyApp extends StatelessWidget {
  final Box<Transaction> transactionBox;

  MyApp(this.transactionBox);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(transactionBox),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF78866B),
          scaffoldBackgroundColor: Color(0xFFF5F5DC),
        ),
        home: HomeScreen(),
      ),
    );
  }
}