// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

// class ChartSumary extends StatelessWidget {
//   // final dataWon, dataLose;
//   ChartSumary() {
//     _generateData();
//   }
//   List<charts.Series<TotalDataCharts, String>> _seriesData;

//   _generateData() {
//     var dataWon = [
//       new TotalDataCharts('2021-08-01', 10000),
//       new TotalDataCharts('2021-09-01', 0),
//       new TotalDataCharts('2021-10-01', 2000),
//     ];
//     var dataLose = [
//       new TotalDataCharts('2021-08-01', 2500),
//       new TotalDataCharts('2021-09-01', 1200),
//       new TotalDataCharts('2021-10-01', 80),
//     ];
//     //กุจะอัป
//     _seriesData.add(
//       charts.Series(
//         domainFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.date,
//         measureFn: (TotalDataCharts totalDataCharts, _) =>
//             totalDataCharts.total,
//         id: 'Win',
//         data: dataWon,
//         fillPatternFn: (_, __) => charts.FillPatternType.solid,
//         fillColorFn: (TotalDataCharts totalDataCharts, _) =>
//             charts.ColorUtil.fromDartColor(Colors.green),
//       ),
//     );
//     _seriesData.add(
//       charts.Series(
//         domainFn: (TotalDataCharts totalDataCharts, _) => totalDataCharts.date,
//         measureFn: (TotalDataCharts totalDataCharts, _) =>
//             totalDataCharts.total,
//         id: 'Lose',
//         data: dataLose,
//         fillPatternFn: (_, __) => charts.FillPatternType.solid,
//         fillColorFn: (TotalDataCharts totalDataCharts, _) =>
//             charts.ColorUtil.fromDartColor(Colors.red),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Object>(
//         stream: _generateData(),
//         builder: (context, snapshot) {
//           return Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             height: MediaQuery.of(context).size.width * 0.7,
//             child: charts.BarChart(
//               _seriesData,
//               animate: true,
//               barGroupingType: charts.BarGroupingType.grouped,
//               animationDuration: Duration(seconds: 5),
//             ),
//           );
//         });
//   }
// }

// class TotalDataCharts {
//   String date;
//   int total;
//   TotalDataCharts(this.date, this.total);
// }
