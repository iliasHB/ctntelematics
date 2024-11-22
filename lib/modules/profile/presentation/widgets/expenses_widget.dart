import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_style.dart';

class VehicleExpensesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Expenses', style: AppStyle.pageTitle,),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spent Overview
            const Text(
              'Spent Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '\$5,000.00',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'October',
                  items: <String>['October', 'September', 'August']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Categories
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategory('Maintenance', Colors.blue, '\$100.00'),
                    const SizedBox(height: 10,),
                    _buildCategory('Fuel', Colors.green, '\$300.00'),
                    const SizedBox(height: 10,),
                    _buildCategory('Engine Oil', Colors.orange, '\$250.00'),
                    const SizedBox(height: 10,),
                    _buildCategory('Tire', Colors.red, '\$400.00'),
                  ],
                ),
              ),
            ),
            // Total Expense and Bar Chart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Expense',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: 'This Week',
                  items: <String>['This Week', 'This Month', 'This Year']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: _buildBarChart(),
            ),
            const Divider(),
            // Recent Transactions
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Filter',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildTransaction(
                    'Fuel Purchase',
                    'OBD plug and Play',
                    'October 8, 2024 at 3:25PM',
                    '\$100.00',
                    Colors.green,
                  ),
                  _buildTransaction(
                    'Tire Replacement',
                    'OBD plug and Play',
                    'October 8, 2024 at 2:35PM',
                    '\$150.00',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String name, Color color, String amount) {
    return Row(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 5,
              backgroundColor: color,
            ),
            const SizedBox(width: 4),
            Text(name),
          ],
        ),
        const Spacer(),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTransaction(
      String title, String subtitle, String date, String amount, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.receipt, color: color),
        title: Text(title),
        subtitle: Text('$subtitle\n$date'),
        trailing: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildBarChart() {
    final data = [
      Expenses('Sun', 400),
      Expenses('Mon', 300),
      Expenses('Tue', 300),
      Expenses('Wed', 300),
      Expenses('Thu', 300),
      Expenses('Fri', 200),
      Expenses('Sat', 300),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 500,
        barGroups: data.map((expense) {
          return BarChartGroupData(
            x: data.indexOf(expense),
            barRods: [
              BarChartRodData(
                toY: expense.amount,
                color: Colors.green,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              getTitlesWidget: (value, _) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    data[value.toInt()].day,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class Expenses {
  final String day;
  final double amount;

  Expenses(this.day, this.amount);
}