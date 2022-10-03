import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';

import 'NoteDetail.dart';
import 'AddNote.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  final f = new DateFormat('dd-MM-yyyy hh:mm');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      getMeeting();
    });
  }

  List<Meeting> _list = [];
  getMeeting() async {
    if (_userViewModel == null || _meetingViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
      _meetingViewModel =
          await Provider.of<MeetingViewModel>(context, listen: false);
    }

    await _meetingViewModel.getMeetingReport(_userViewModel.getToken);
    _meetingViewModel.getMeetingListReport.map((meeting) {
      if (meeting.email == _userViewModel.getUser.email) {
        _list.add(meeting);
      }
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel = Provider.of<MeetingViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Toplantı"),
        ),
        body: _list.length == 0
            ? Center(
                child: Text("Herhangi bir toplantı kaydınız bulunmamaktadır."),
              )
            : ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${_list[index].title}"),
                    subtitle: Text("${f.format(_list[index].startingDate)}"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NoteDetail(_list[index]);
                      }));
                    },
                  );
                }));
  }
}
