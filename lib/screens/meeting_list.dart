import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adobe_xd/specific_rect_clip.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';

class MeetingList extends StatefulWidget {
  @override
  _MeetingListState createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;

  var tarih;
  var oneSec = const Duration(minutes: 10);
  var tarihSaniye = const Duration(seconds: 10);
  @override
  void initState() {
    super.initState();
    getMeeting();
    tarihKontrolu();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tarihKontrolu();
    super.dispose();
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  tarihKontrolu() {
    tarih = DateTime.now();
    if (mounted) {
      setState(() {});
    }
  }

  List<Meeting> _liste = [];
  List<attendees> attendees = [];
  getMeeting() async {
    if (_userViewModel == null || _meetingViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
      _meetingViewModel =
          await Provider.of<MeetingViewModel>(context, listen: false);
    }

    await _meetingViewModel.getMeeting(_userViewModel.getToken);
    final currentTime = DateTime.now();
    final onDakika = DateTime(currentTime.year, currentTime.month,
        currentTime.day, currentTime.hour, currentTime.minute + 10);

    _meetingViewModel.getMeetingList.map((meeting) {
      if (onDakika.isAfter(meeting.startingDateTarihi) &&
          onDakika.isBefore(meeting.endDateTarihi)) {
        if (_liste.isEmpty) {
          _liste.add(meeting);
          if (_liste[0].attendees != null) {
            _liste.map((kat) => attendees = kat.attendees).toList();
          }
          setState(() {});
        } else if (_liste[0].startingDateTarihi == meeting.startingDateTarihi &&
            _liste[0].endDateTarihi == meeting.endDateTarihi &&
            _liste[0].companyName == meeting.companyName &&
            _liste[0].title == meeting.title &&
            _liste[0].subject == meeting.subject) {
          return;
        } else if (_liste[0].startingDateTarihi != meeting.startingDateTarihi ||
            _liste[0].endDateTarihi != meeting.endDateTarihi ||
            _liste[0].companyName != meeting.companyName ||
            _liste[0].title != meeting.title ||
            _liste[0].subject != meeting.subject) {
          _liste.clear();
          attendees.clear();
          _liste.add(meeting);
          if (_liste[0].attendees != null) {
            _liste.map((kat) => attendees = kat.attendees).toList();
          }
          setState(() {});
        }
        return;
      } /* else {
        _liste.clear();
        attendees.clear();
      } */
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel = Provider.of<MeetingViewModel>(context, listen: false);
    new Timer.periodic(oneSec, (Timer t) {
      getMeeting();
    });
    new Timer.periodic(tarihSaniye, (Timer t) {
      tarihKontrolu();
    });
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [
                  const Color(0xff3cc7c2),
                  const Color(0xff61a4f1),
                  const Color(0xff478de0),
                  const Color(0xff398ae5)
                ],
                stops: [0.0, 0.439, 0.715, 1.0],
              ),
              border: Border.all(width: 1.0, color: const Color(0xff000000)),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.21,
            height: MediaQuery.of(context).size.height * 0.10,
            padding: EdgeInsets.only(bottom: 50),
            child: Transform.translate(
              offset: Offset(639.0, 161.0),
              child: Center(
                child: _userViewModel == null
                    ? Text("")
                    : Text(
                        capitalize(
                            '${_userViewModel.getUser.toplantiSalonAdi} '),
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 18,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
              ),
            ),
          ),
          _liste.isEmpty
              ? Transform.translate(
                  offset: Offset(659.0, 376.0),
                  child: Text(
                    'AKTIF TOPLANTI YOK',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 16,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              : ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(519.0, 214.0),
                            child: Text(
                              'Firma Adı :',
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(687.0, 214.0),
                            child: Text(
                              '${_liste[index].companyName}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(519.0, 256.0),
                          child: Text(
                            'Toplantının Baslığı : ',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 16,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(687.0, 256.0),
                            child: Text(
                              '${_liste[index].title}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(519.0, 298.0),
                            child: Text(
                              'Toplantının subjectsu : ',
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Transform.translate(
                            offset: Offset(687.0, 298.0),
                            child: Text(
                              '${_liste[index].subject}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 16,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(519.0, 584.0),
                            child: Text(
                              'Baş. Saati :',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(600.0, 584.0),
                            child: Text(
                              '${DateFormat('dd.MM.yyyy H:mm').format(_liste[index].startingDateTarihi)}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(519.0, 632.0),
                            child: Text(
                              'Bitiş Saati :',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Transform.translate(
                            offset: Offset(600.0, 632.0),
                            child: Text(
                              '${DateFormat('dd.MM.yyyy H:mm').format(_liste[index].endDateTarihi)}',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
          // Adobe XD layer: 'Katılımcılar' (group)
          attendees.isEmpty
              ? Center()
              : Stack(
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(519.0, 466.0),
                      child: Text(
                        'Katılımcılar :',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(687.0, 466.0),
                      child: SpecificRectClip(
                        rect: Rect.fromLTWH(0, 0, 262, 112),
                        child: UnconstrainedBox(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 269,
                            height: 108,
                            child: GridView.count(
                              primary: false,
                              padding: EdgeInsets.all(0),
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 7,
                              crossAxisCount: 2,
                              childAspectRatio: 6.2381,
                              children: attendees.map((map) {
                                return Transform.translate(
                                  offset: Offset(-687.0, -466.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Transform.translate(
                                        offset: Offset(687.0, 466.0),
                                        child: Text(
                                          '${map.adSoyad} ,',
                                          style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 14,
                                            color: const Color(0xffffffff),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      /*  Transform.translate(
                                              offset: Offset(773.0, 466.0),
                                              child: Text(
                                                ',',
                                                style: TextStyle(
                                                  fontFamily: 'Segoe UI',
                                                  fontSize: 14,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ), */
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          _userViewModel.getUser.salonOzellikleri[0].wifi
              ? Transform.translate(
                  offset: Offset(742.0, 66.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(25.0, 25.0)),
                      color: const Color(0xffffffff),
                      border: Border.all(
                          width: 2.0, color: const Color(0xff3cc7c2)),
                    ),
                  ),
                )
              : Container(),

          _userViewModel.getUser.salonOzellikleri[0].projektor
              ? Transform.translate(
                  offset: Offset(800.0, 66.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(25.0, 25.0)),
                      color: const Color(0xffffffff),
                      border: Border.all(
                          width: 2.0, color: const Color(0xff3cc7c2)),
                    ),
                  ),
                )
              : Container(),
          _userViewModel.getUser.salonOzellikleri[0].beyazTahta
              ? Transform.translate(
                  offset: Offset(857.0, 66.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(25.0, 25.0)),
                      color: const Color(0xffffffff),
                      border: Border.all(
                          width: 2.0, color: const Color(0xff3cc7c2)),
                    ),
                  ),
                )
              : Container(),
          Transform.translate(
            offset: Offset(802.0, 68.0),
            child: Container(
              width: 47.0,
              height: 47.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9.0),
                image: DecorationImage(
                  image: const AssetImage('assets/images/projector_icon.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          _userViewModel.getUser.salonOzellikleri[0].telefon
              ? Transform.translate(
                  offset: Offset(912.0, 66.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(25.0, 25.0)),
                      color: const Color(0xffffffff),
                      border: Border.all(
                          width: 2.0, color: const Color(0xff3cc7c2)),
                    ),
                  ),
                )
              : Container(),
          Transform.translate(
            offset: Offset(923.0, 77.0),
            child:
                // Adobe XD layer: 'icons8-phone-100' (shape)
                Container(
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                image: DecorationImage(
                  image: const AssetImage('assets/images/phone_icon.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(865.0, 74.0),
            child:
                // Adobe XD layer: 'icons8-interactive-…' (shape)
                Container(
              width: 34.0,
              height: 34.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/white_board_icon.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(751.0, 75.0),
            child:
                // Adobe XD layer: 'icons8-wi-fi-100' (shape)
                Container(
              width: 33.0,
              height: 33.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/wifi.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          //---------------------------------------LOGO------------------------------------------------------
          /*  Transform.translate(
            offset: Offset(66.0, 173.0),
            child:
                // Adobe XD layer: 'logoE' (shape)
                Container(
              width: 350,
              height: 57,
              decoration: BoxDecoration(
                /*     borderRadius: BorderRadius.circular(10.0), */
                image: DecorationImage(
                  image: const AssetImage('assets/images/ecnlogo.png'),
                  fit: BoxFit.fill,
                ),
                /* border: Border.all(width: 2.0, color: const Color(0xff3cc7c2)), */
              ),
            ),
          ), */
          //---------------------------------------LOGO------------------------------------------------------

          /*  Transform.translate(
            offset: Offset(467.5, 55.5),
            child: SvgPicture.string(
              _svg_v6h9f6,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(45.0, 654.0),
            child:
                // Adobe XD layer: 'logoE' (shape)
                Container(
              width: 67.0,
              height: 50.8,
              decoration: BoxDecoration(
                /*  borderRadius: BorderRadius.circular(19.0), */
                image: DecorationImage(
                  image: const AssetImage('assets/images/amblem.png'),
                  fit: BoxFit.fill,
                ),
                /*  border: Border.all(width: 2.0, color: const Color(0xff3cc7c2)), */
              ),
            ),
          ), */
          /*       Transform.translate(
            offset: Offset(284.0, 298.0),
            child:
                // Adobe XD layer: 'circle-3' (shape)
                Container(
              width: 124.0,
              height: 124.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(62.0, 62.0)),
                color: const Color(0xff61a4f1),
              ),
            ),
          ), */

          Transform.translate(
            offset: Offset(252.0, 300.0),
            child: Text(
              '${DateFormat("mm").format(tarih)}',
              style: TextStyle(
                  fontFamily: 'Melbourne',
                  fontSize: 59,
                  color: const Color(0xffffffff),
                  letterSpacing: -1.18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),

          Transform.translate(
            offset: Offset(146.0, 300.0),
            child: Text(
              '${DateFormat("H").format(tarih)}',
              style: TextStyle(
                  fontFamily: 'Melbourne',
                  fontSize: 59,
                  color: const Color(0xffffffff),
                  letterSpacing: -1.18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(210.0, 295.0),
            child: Text(
              ' : ',
              style: TextStyle(
                  fontFamily: 'Melbourne',
                  fontSize: 59,
                  color: const Color(0xffffffff),
                  letterSpacing: -1.18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(170.0, 247.0),
            child: Text(
              '${DateFormat('dd.MM.yyyy').format(tarih)}',
              style: TextStyle(
                fontFamily: 'Signika Negative',
                fontSize: 30,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(61.0, 73.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Çıkmak istediğinize emin misiniz ?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Hayır'),
                          ),
                          FlatButton(
                            onPressed: () async {
                              _userViewModel.logout(context);
                            },
                            child: Text('Evet'),
                          ),
                        ],
                      );
                    });
              },
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 33,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_v6h9f6 =
    '<svg viewBox="467.5 55.5 1.0 657.0" ><path transform="translate(467.5, 55.5)" d="M 0 0 L 0 657" fill="none" stroke="#ffffff" stroke-width="2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_gunklo =
    '<svg viewBox="74.0 298.0 229.0 124.0" ><path transform="translate(74.0, 298.0)" d="M 62 0 C 96.24165344238281 0 124 27.75834655761719 124 62 C 124 96.24165344238281 96.24165344238281 124 62 124 C 27.75834655761719 124 0 96.24165344238281 0 62 C 0 27.75834655761719 27.75834655761719 0 62 0 Z" fill="#398ae5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(179.0, 298.0)" d="M 105.0003051757813 62.00010299682617 C 105.0003051757813 49.87224197387695 108.4810104370117 38.56005096435547 114.500129699707 29.00402069091797 C 120.5193634033203 38.56005096435547 124.0002059936523 49.87224197387695 124.0002059936523 62.00010299682617 C 124.0002059936523 74.12796020507813 120.5193634033203 85.44013977050781 114.500129699707 94.99617004394531 C 108.4810104370117 85.44013977050781 105.0003051757813 74.12796020507813 105.0003051757813 62.00010299682617 Z" fill="#527877" fill-opacity="0.49" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(74.0, 298.0)" d="M 105.0003051757813 62.00010299682617 C 105.0003051757813 49.87224197387695 108.4810104370117 38.56005096435547 114.500129699707 29.00402069091797 C 120.5193634033203 38.56005096435547 124.0002059936523 49.87224197387695 124.0002059936523 62.00010299682617 C 124.0002059936523 74.12796020507813 120.5193634033203 85.44013977050781 114.500129699707 94.99617004394531 C 108.4810104370117 85.44013977050781 105.0003051757813 74.12796020507813 105.0003051757813 62.00010299682617 Z" fill="#4d5b5b" fill-opacity="0.49" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(5324.0, 398.0)" d="M -5032.00048828125 -32.49984741210938 C -5032.00048828125 -33.32828521728516 -5031.32861328125 -34.00012969970703 -5030.5 -34.00012969970703 C -5029.67138671875 -34.00012969970703 -5028.99951171875 -33.32828521728516 -5028.99951171875 -32.49984741210938 C -5028.99951171875 -31.67140579223633 -5029.67138671875 -30.99956130981445 -5030.5 -30.99956130981445 C -5031.32861328125 -30.99956130981445 -5032.00048828125 -31.67140579223633 -5032.00048828125 -32.49984741210938 Z M -5032.00048828125 -42.5004768371582 C -5032.00048828125 -43.32891845703125 -5031.32861328125 -43.9995002746582 -5030.5 -43.9995002746582 C -5029.67138671875 -43.9995002746582 -5028.99951171875 -43.32891845703125 -5028.99951171875 -42.5004768371582 C -5028.99951171875 -41.67203903198242 -5029.67138671875 -41.00019454956055 -5030.5 -41.00019454956055 C -5031.32861328125 -41.00019454956055 -5032.00048828125 -41.67203903198242 -5032.00048828125 -42.5004768371582 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(5219.0, 398.0)" d="M -5032.00048828125 -32.49984741210938 C -5032.00048828125 -33.32828521728516 -5031.32861328125 -34.00012969970703 -5030.5 -34.00012969970703 C -5029.67138671875 -34.00012969970703 -5028.99951171875 -33.32828521728516 -5028.99951171875 -32.49984741210938 C -5028.99951171875 -31.67140579223633 -5029.67138671875 -30.99956130981445 -5030.5 -30.99956130981445 C -5031.32861328125 -30.99956130981445 -5032.00048828125 -31.67140579223633 -5032.00048828125 -32.49984741210938 Z M -5032.00048828125 -42.5004768371582 C -5032.00048828125 -43.32891845703125 -5031.32861328125 -43.9995002746582 -5030.5 -43.9995002746582 C -5029.67138671875 -43.9995002746582 -5028.99951171875 -43.32891845703125 -5028.99951171875 -42.5004768371582 C -5028.99951171875 -41.67203903198242 -5029.67138671875 -41.00019454956055 -5030.5 -41.00019454956055 C -5031.32861328125 -41.00019454956055 -5032.00048828125 -41.67203903198242 -5032.00048828125 -42.5004768371582 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_poosox =
    '<svg viewBox="240.0 355.0 3.0 13.0" ><path transform="translate(5272.0, 399.0)" d="M -5032.00048828125 -32.49984741210938 C -5032.00048828125 -33.32828521728516 -5031.32861328125 -34.00012969970703 -5030.5 -34.00012969970703 C -5029.67138671875 -34.00012969970703 -5028.99951171875 -33.32828521728516 -5028.99951171875 -32.49984741210938 C -5028.99951171875 -31.67140579223633 -5029.67138671875 -30.99956130981445 -5030.5 -30.99956130981445 C -5031.32861328125 -30.99956130981445 -5032.00048828125 -31.67140579223633 -5032.00048828125 -32.49984741210938 Z M -5032.00048828125 -42.5004768371582 C -5032.00048828125 -43.32891845703125 -5031.32861328125 -43.9995002746582 -5030.5 -43.9995002746582 C -5029.67138671875 -43.9995002746582 -5028.99951171875 -43.32891845703125 -5028.99951171875 -42.5004768371582 C -5028.99951171875 -41.67203903198242 -5029.67138671875 -41.00019454956055 -5030.5 -41.00019454956055 C -5031.32861328125 -41.00019454956055 -5032.00048828125 -41.67203903198242 -5032.00048828125 -42.5004768371582 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
