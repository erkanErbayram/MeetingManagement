import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';

class Saatler extends StatefulWidget {
  const Saatler({Key key}) : super(key: key);

  @override
  _SaatlerState createState() => _SaatlerState();
}

class _SaatlerState extends State<Saatler> {
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  int index = -1;
  int i = 0;
  List _liste = [0, 0, 0, 0, 0, 0, 0];
  int toplamSaat = 0;
  int basSaat = 0;
  int bitSaat = 0;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getHour();
    });
  }

  getHour() async {
    if (_userViewModel == null || _meetingViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
      _meetingViewModel =
          await Provider.of<MeetingViewModel>(context, listen: false);
    }
    _meetingViewModel.getHour();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      index = -1;
    });
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        /* color: const Color(0xff2c4260),  */
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.black,
                      /*   color: Colors.white, */
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                margin: 25,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Pzt';
                    case 1:
                      return 'Salı';
                    case 2:
                      return 'Çrş';
                    case 3:
                      return 'Prş';
                    case 4:
                      return 'Cuma';
                    case 5:
                      return 'Cmt';
                    case 6:
                      return 'Pzr';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: _meetingViewModel.getMeetingListHour.map((e) {
              index++;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                      y: double.parse(e.toString()),
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
