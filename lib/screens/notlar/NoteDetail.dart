import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';

import 'AddNote.dart';

class NoteDetail extends StatefulWidget {
  final Meeting meeting;
  NoteDetail(this.meeting);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  @override
  void initState() {
    // TODO: implement initState
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

    await _meetingViewModel.getMeetingById(
        _userViewModel.getToken, widget.meeting.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel = Provider.of<MeetingViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("${_meetingViewModel.getMeetingByID.title}"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddNote(_meetingViewModel.getMeetingByID);
                })).then((back) => {
                      if (back == "success")
                        {
                          setState(() {
                            getMeeting();
                          })
                        }
                    });
              })
        ],
      ),
      body: _meetingViewModel.getMeetingByID.Notes.length == 0
          ? Center(
              child: Text("Herhangi Bir notunuz bulunmamaktadır."),
            )
          : ListView.builder(
              itemCount: _meetingViewModel.getMeetingByID.Notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text("${_meetingViewModel.getMeetingByID.Notes[index]}"),
                );
              }),
    );
  }
}
