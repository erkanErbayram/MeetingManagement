import 'package:flutter/material.dart';
import 'package:takvim_uygulamasi/screens/rapor/saatler.dart';

import 'pie_chart.dart';
import 'samples/line_chart_sample1.dart';
/* import 'samples/line_chart_sample2.dart'; */

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      body: Container(
        /*  color: const Color(0xff262545), */
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aya Göre Katılınan Toplantılar',
                  style: TextStyle(
                      /*  color: Color(
                        0xff6f6f97,
                      ), */
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              child: BarChartSample3(),
            ),
            const SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Haftalık Saatlik Toplantı',
                  style: TextStyle(
                      /*  color: Color(
                        0xff6f6f97,
                      ), */
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              child: Saatler(),
            ),
            const SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tüm Toplantılar',
                  style: TextStyle(
                      /* color: Color(
                        0xff6f6f97,
                      ), */
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              child: PieChartSample2(),
            ),
            const SizedBox(
              height: 22,
            ),
          ],
        ),
      ),
    );
  }
}
