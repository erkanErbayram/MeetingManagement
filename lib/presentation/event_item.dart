import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';

import 'recurring_event_dialog.dart';

class EventItem extends StatefulWidget {
  final Event _calendarEvent;
  final DeviceCalendarPlugin _deviceCalendarPlugin;
  final bool _isReadOnly;
  final Function(Event) _onTapped;
  final VoidCallback _onLoadingStarted;
  final Function(bool) _onDeleteFinished;

  EventItem(
      this._calendarEvent,
      this._deviceCalendarPlugin,
      this._onLoadingStarted,
      this._onDeleteFinished,
      this._onTapped,
      this._isReadOnly);

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  final double _eventFieldNameWidth = 75.0;
  @override
  void initState() {
    super.initState();
    /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp){
    _
  }), */
    getRoom();
  }

  /*  @override
  void dispose() async {
    _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel =
        // ignore: await_only_futures
        await Provider.of<MeetingViewModel>(context, listen: false);
    super.dispose();
  }
 */
  Future getRoom() async {
    // ignore: await_only_futures
    _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel =
        // ignore: await_only_futures
        await Provider.of<MeetingViewModel>(context, listen: false);
    await _userViewModel.getMeetingRoom(_userViewModel.getToken);
    /* await _meetingRoomViewModel.getMeetingRoom(_userViewModel.getToken); */
    // ignore: await_only_futures
    await _userViewModel.getRoom.map((room) {
      if (room.toplantiOdasiMi && room.toplantiSalonAdi != null) {}
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*     widget._onTapped(widget._calendarEvent); */
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: FlutterLogo(),
            ),
            /*     ListTile(
                title: Text(_calendarEvent.title ?? ''),
                subtitle: Text(_calendarEvent.description ?? '')), */
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Başlık :'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget._calendarEvent.title ?? ''),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('subject :'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget._calendarEvent.description ?? ''),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Baş. Tarihi : '),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget._calendarEvent == null
                            ? ''
                            : DateFormat('dd-MM-yyyy')
                                .add_jm()
                                .format(widget._calendarEvent.start)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Bitiş Tarihi : '),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget._calendarEvent.end == null
                            ? ''
                            : DateFormat('dd-MM-yyyy')
                                .add_jm()
                                .format(widget._calendarEvent.end)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  /*    Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Tüm gün :'),
                        ),
                        
                        Text(widget._calendarEvent.allDay != null &&
                                widget._calendarEvent.allDay
                            ? 'Evet'
                            : 'Hayır')
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ), */
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Toplantı Salonu : '),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            widget._calendarEvent?.location ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  /* SizedBox(
                    height: 10.0,
                  ),
                   Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('URL'),
                        ),
                        Expanded(
                          child: Text(
                            _calendarEvent?.url?.data?.contentText ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ), */
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth + 5,
                          child: Text('Katılımcılar :'),
                        ),
                        Expanded(
                          child: Text(
                            widget._calendarEvent?.attendees
                                    ?.where((a) => a.name?.isNotEmpty ?? false)
                                    ?.map((a) => a.name)
                                    ?.join(', ') ??
                                '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: [
                if (!widget._isReadOnly) ...[
                  /*   IconButton(
                    onPressed: () {
                      widget._onTapped(widget._calendarEvent);
                    },
                    icon: Icon(Icons.edit),
                  ), */
                  IconButton(
                    onPressed: () async {
                      await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          if (widget._calendarEvent.recurrenceRule == null) {
                            return AlertDialog(
                              title: Text('Silmek istediğinize emin misiniz ?'),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hayır'),
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    _meetingViewModel.deleteMeeting(
                                        _userViewModel.getToken,
                                        widget._calendarEvent.start.toString());
                                    Navigator.of(context).pop();
                                    widget._onLoadingStarted();
                                    final deleteResult = await widget
                                        ._deviceCalendarPlugin
                                        .deleteEvent(
                                            widget._calendarEvent.calendarId,
                                            widget._calendarEvent.eventId);
                                    widget._onDeleteFinished(
                                        deleteResult.isSuccess &&
                                            deleteResult.data);
                                  },
                                  child: Text('Evet'),
                                ),
                              ],
                            );
                          } else {
                            return RecurringEventDialog(
                                widget._deviceCalendarPlugin,
                                widget._calendarEvent,
                                widget._onLoadingStarted,
                                widget._onDeleteFinished);
                          }
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                ] else ...[
                  IconButton(
                    onPressed: () {
                      widget._onTapped(widget._calendarEvent);
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
