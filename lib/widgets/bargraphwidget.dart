import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<SalesData, String>>[
            BarSeries<SalesData, String>(
              dataSource: <SalesData>[
                SalesData('Jan', 30),
                SalesData('Feb', 60),
                SalesData('Mar', 40),
                SalesData('Apr', 70),
                SalesData('May', 50),
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String year;
  final int sales;

  SalesData(this.year, this.sales);
}
