import 'package:budget/cubits/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC), 
      appBar: AppBar(
        backgroundColor: Color(0xFF78866B), 
        title: Text('Личные Финансы'),
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          final filteredTransactions = state.filter == 'all'
              ? state.transactions
              : state.transactions
                  .where((t) => t.isIncome == (state.filter == 'доход'))
                  .toList();

          double totalIncome = state.transactions
              .where((t) => t.isIncome)
              .fold(0.0, (sum, t) => sum + t.amount);
          double totalExpense = state.transactions
              .where((t) => !t.isIncome)
              .fold(0.0, (sum, t) => sum + t.amount);

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Color(0xFFF0EAD6),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Баланс: ₽${state.balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF78866B),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                if (totalIncome > 0)
                                  PieChartSectionData(
                                    value: totalIncome,
                                    title: 'Доход',
                                    color: Colors.green,
                                    radius: 50,
                                  ),
                                if (totalExpense > 0)
                                  PieChartSectionData(
                                    value: totalExpense,
                                    title: 'Расходы',
                                    color: Colors.red,
                                    radius: 50,
                                  ),
                              ],
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton('Все', 'all'),
                    FilterButton('Доход', 'доход'),
                    FilterButton('Расходы', 'расходы'),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return Card(
                        color: Color(0xFFF0EAD6),
                        child: ListTile(
                          title: Text(transaction.title),
                          subtitle: Text(transaction.date.toString()),
                          trailing: Text(
                            '${transaction.isIncome ? '+' : '-'}₽${transaction.amount}',
                            style: TextStyle(
                              color: transaction.isIncome
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF78866B),
        child: Icon(Icons.add),
        onPressed: () => _showAddTransactionDialog(context),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  bool isIncome = true;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color(0xFFF0EAD6),
      title: Text('Новая Транзакция'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Заголовок'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Сумма'),
              ),
              SwitchListTile(
                title: Text('Доход'),
                value: isIncome,
                onChanged: (value) {
                  setState(() {
                    isIncome = value; // Обновляем состояние и UI
                  });
                },
                activeColor: Color(0xFF78866B),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отменить'),
        ),
        TextButton(
          onPressed: () {
            final cubit = context.read<TransactionCubit>();
            cubit.addTransaction(
              titleController.text,
              double.parse(amountController.text),
              isIncome,
            );
            Navigator.pop(context);
          },
          child: Text('Добавить'),
        ),
      ],
    ),
  );
}
}

class FilterButton extends StatelessWidget {
  final String label;
  final String filter;

  FilterButton(this.label, this.filter);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF78866B),
      ),
      onPressed: () => context.read<TransactionCubit>().setFilter(filter),
      child: Text(label),
    );
  }
}