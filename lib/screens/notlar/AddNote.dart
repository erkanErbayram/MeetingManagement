import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/bullet.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';
import 'package:takvim_uygulamasi/screens/Notes/Notes.dart';

class AddNote extends StatefulWidget {
  final Meeting meeting;
  AddNote(this.meeting);
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  static int counter = 0;
  var formKey = GlobalKey<FormState>();
  String Notes;
  List<String> listNot = [];

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel = Provider.of<MeetingViewModel>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("${widget.meeting.title}"),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              width: width,
              height: height - 85,
              /* decoration: BoxDecoration(
                    color: const Color(0xff292929),
                    border: Border.all(width: 1.0, color: const Color(0xff707070)),
                  ), */
              child: Column(
                children: <Widget>[
                  Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            width: width,
                            height: 41.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              border:
                                  Border.all(width: 1.0, color: Colors.blue),
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (text) {
                                Notes = text;
                              },
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.note_add,
                                ),
                                hintText: 'Not Giriniz.',
                                hintStyle: TextStyle(
                                  color: const Color(0xff4B4949),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                listNot.add(Notes);
                                formKey.currentState.reset();
                              });
                            },
                            child: Container(
                              width: width * 0.3,
                              height: height * 0.05,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19.0),
                                color: Colors.blue,
                                border: Border.all(
                                    width: 2.0, color: const Color(0xffffffff)),
                              ),
                              child: Center(
                                child: Text(
                                  'Not Ekle',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 16,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: height - 290,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listNot.length,
                            itemBuilder: _listWidget,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        listNot.length > 0
                            ? InkWell(
                                onTap: () async {
                                  await _meetingViewModel.notMeeting(
                                      _userViewModel.getToken,
                                      widget.meeting.id,
                                      listNot);
                                  Navigator.pop(context, "success");
                                },
                                child: Container(
                                  width: width * 0.3,
                                  height: height * 0.05,
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19.0),
                                    color: Colors.blue,
                                    border: Border.all(
                                        width: 2.0,
                                        color: const Color(0xffffffff)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Kaydet',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 16,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listWidget(BuildContext context, int index) {
    counter++;

    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          listNot.removeAt(index);
        });
      },
      child: Container(
        child: ListTile(
          title: Bullet(listNot[index]),
        ),
      ),
    );
  }
}
