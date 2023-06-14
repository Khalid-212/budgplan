//  a page that displays a chart of the data in the database named ChartPage.dart
import 'dart:math';

import 'package:budgplan/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartPage extends StatefulWidget {
  final List<Data> dataList;

  const BarChartPage({Key? key, required this.dataList}) : super(key: key);

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  late List<charts.Series<Data, String>> _seriesData;

  @override
  void initState() {
    super.initState();
    _seriesData = [
      charts.Series(
        id: 'Data',
        data: widget.dataList,
        domainFn: (Data series, _) => series.category,
        measureFn: (Data series, _) => series.amount,
        colorFn: (Data series, _) => charts.ColorUtil.fromDartColor(
          getRandomColor(),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: charts.BarChart(
                _seriesData,
                animate: true,
                animationDuration: const Duration(seconds: 5),
                behaviors: [
                  charts.DatumLegend(
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.purple.shadeDefault,
                      fontFamily: 'Georgia',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    var random = new Random();
    var red = random.nextInt(255);
    var green = random.nextInt(255);
    var blue = random.nextInt(255);

    return Color.fromARGB(255, red, green, blue);
  }
}
