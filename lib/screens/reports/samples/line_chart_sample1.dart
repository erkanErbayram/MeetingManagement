import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';

class BarChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  int index = -1;
  int i = 0;
  List _liste = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getMeeting();
    });
  }

  getMeeting() async {
    if (_userViewModel == null || _meetingViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
      _meetingViewModel =
          await Provider.of<MeetingViewModel>(context, listen: false);
    }

    await _meetingViewModel.getMeetingReport(_userViewModel.getToken);

    _meetingViewModel.getMeetingListRapor.map((meeting) {
      if (meeting.email == _userViewModel.getUser.email) {
        _liste[
            _meetingViewModel.getMeetingListRapor[i].startingDateTarihi.month -
                1] += 1;
      }
      i++;
    }).toList();
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
                    fontSize: 8),
                margin: 25,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Ocak';
                    case 1:
                      return 'Subat';
                    case 2:
                      return 'Mart';
                    case 3:
                      return 'Nisan';
                    case 4:
                      return 'Mayıs';
                    case 5:
                      return 'Haziran';
                    case 6:
                      return 'Temmuz';
                    case 7:
                      return 'Ağustos';
                    case 8:
                      return 'Eylül';
                    case 9:
                      return 'Ekim';
                    case 10:
                      return 'Kasım';
                    case 11:
                      return 'Aralık';
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
            barGroups: _liste.map((e) {
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
