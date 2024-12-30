import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final List<Map<String, dynamic>> _transactions = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  void _addTransaction() {
    final String category = _categoryController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (category.isNotEmpty && amount != null && amount > 0) {
      setState(() {
        _transactions.add({'category': category, 'amount': amount});
      });
      _categoryController.clear();
      _amountController.clear();
    }
  }

  Map<String, double> _getCategoryData() {
    final Map<String, double> data = {};
    for (var transaction in _transactions) {
      if (data.containsKey(transaction['category'])) {
        data[transaction['category']] =
            data[transaction['category']]! + transaction['amount'];
      } else {
        data[transaction['category']] = transaction['amount'];
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = _getCategoryData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTransaction,
                  child: Text('Add Transaction'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _transactions.isEmpty
                ? Center(child: Text('No transactions added yet.'))
                : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text(transaction['category']),
                  subtitle: Text('\$${transaction['amount']}'),
                );
              },
            ),
          ),
          if (categoryData.isNotEmpty)
            Container(
              height: 300,
              child: ExpensePieChart(data: categoryData),
            ),
        ],
      ),
    );
  }
}

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> data;

  ExpensePieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: data,
      animationDuration: Duration(milliseconds: 800),
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: "Expenses",
      colorList: [Colors.blue, Colors.red, Colors.green, Colors.yellow],
      legendOptions: LegendOptions(
        showLegends: true,
        legendPosition: LegendPosition.bottom,
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValues: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}
