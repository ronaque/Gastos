import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Resumo extends StatefulWidget {
  const Resumo({super.key});

  @override
  _ResumoState createState() => _ResumoState();
}

class _ResumoState extends State<Resumo> {
  final TooltipBehavior _tooltip = TooltipBehavior(enable: true);
  List<_ChartData> data = [
    _ChartData('Jan', 12, 15),
    _ChartData('Fev', 15, 30),
    _ChartData('Mar', 30, 6.4),
    _ChartData('Abr', 6.4, 14),
    _ChartData('Mai', 14, 16),
    _ChartData('Jun', 16, 45),
    _ChartData('Jul', 45, 23),
    _ChartData('Ago', 23, 25),
    _ChartData('Set', 25, 10),
    _ChartData('Out', 10, 5),
    _ChartData('Nov', 5, 19),
    _ChartData('Dez', 19, 12),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // !! Tabela mensal !!
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff0D47A1))),
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.navigate_before),
                      Text("Julho"),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
                Divider(color: Color(0xff0D47A1)),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Row(
                    children: <Widget>[Text("Gasto: R\$1000,00")],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Row(
                    children: <Widget>[Text("Economizado: R\$ 0,00")],
                  ),
                ),
              ],
            ),
          ),
          // !! Gráfico mensal !!
          SizedBox(
            height: MediaQuery.of(context).size.width *
                0.8, // Defina a altura desejada para o PieChart
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.red,
                    value: 40,
                    title: "Comida",
                    radius: 50,
                  ),
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 60,
                    title: "Bebida",
                    radius: 50,
                  ),
                ],
                centerSpaceRadius: MediaQuery.of(context).size.width * 0.2,
              ),
              swapAnimationCurve: Curves.linear,
              swapAnimationDuration: const Duration(milliseconds: 150),
            ),
          ),
          // !! Tabela anual !!
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff0D47A1))),
            width: MediaQuery.of(context).size.width * 0.8,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.navigate_before),
                  Text("2023"),
                  Icon(Icons.navigate_next),
                ],
              ),
            ),
          ),
          // !! Gráfico anual !!
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis:
                    NumericAxis(minimum: 0, maximum: 40, interval: 10),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  BarSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Gold',
                      color: Colors.greenAccent),
                  BarSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y2,
                      name: 'Gold',
                      color: Colors.redAccent)
                ]),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);

  final String x;
  final double y;
  final double y2;
}
