import 'dart:math';

import 'package:budgplan/Home.dart';
import 'package:budgplan/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'list_page.dart';

class PieChartPage extends StatefulWidget {
  final List<Data> dataList;

  const PieChartPage({Key? key, required this.dataList}) : super(key: key);

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    dataMap = {
      'Transportation': 0,
      'Food': 0,
      'Entertainment': 0,
      'Shopping': 0,
      'Bills': 0,
      'Other': 0,
    };

    widget.dataList.forEach((element) {
      dataMap[element.category] =
          dataMap[element.category]! + element.amount.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    // sum of all the amounts
    var total = 0.0;
    widget.dataList.forEach((element) {
      total = total + element.amount.toDouble();
    });
    var centerText = "Total: $total";

    return Column(
      children: [
        PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 600),
          colorList: const [
            Colors.amber,
            Color.fromARGB(255, 102, 204, 99),
            Color.fromARGB(255, 163, 155, 93),
            Color.fromARGB(255, 1, 188, 208),
            Color.fromARGB(255, 135, 80, 148),
            Color.fromARGB(255, 60, 53, 54),
          ],
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 1.5,
          chartType: ChartType.ring,
          ringStrokeWidth: 48,
          centerText: centerText,
          centerTextStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          legendOptions: const LegendOptions(
            showLegendsInRow: true,
            legendPosition: LegendPosition.bottom,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesOutside: false,
            decimalPlaces: 1,
            chartValueBackgroundColor: Color.fromARGB(255, 112, 98, 82),
            chartValueStyle: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 8,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
