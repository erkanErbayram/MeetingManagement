import 'dart:io';

import 'package:collection/collection.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';

import 'package:takvim_uygulamasi/models/UsersModel.dart';

import '../date_time_picker.dart';
import '../recurring_event_dialog.dart';
import 'event_attendee.dart';
import 'event_reminders.dart';

enum RecurrenceRuleEndType { Indefinite, MaxOccurrences, SpecifiedEndDate }

class CalendarEventPage extends StatefulWidget {
  final Calendar _calendar;
  final Event _event;
  final RecurringEventDialog _recurringEventDialog;
  CalendarEventPage(this._calendar, [this._event, this._recurringEventDialog]);

  @override
  _CalendarEventPageState createState() {
    return _CalendarEventPageState(_calendar, _event, _recurringEventDialog);
  }
}

class _CalendarEventPageState extends State<CalendarEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Calendar _calendar;
  var token = "";
  Event _event;
  DeviceCalendarPlugin _deviceCalendarPlugin;
  final RecurringEventDialog _recurringEventDialog;

  DateTime _startDate;
  TimeOfDay _startTime;

  DateTime _endDate;
  TimeOfDay _endTime;

  bool _autovalidate = false;
  DayOfWeekGroup _dayOfWeekGroup = DayOfWeekGroup.None;

  bool _isRecurringEvent = false;
  bool _isByDayOfMonth = false;
  RecurrenceRuleEndType _recurrenceRuleEndType;
  int _totalOccurrences;
  int _interval;
  DateTime _recurrenceEndDate;
  RecurrenceFrequency _recurrenceFrequency = RecurrenceFrequency.Daily;
  List<DayOfWeek> _daysOfWeek = List<DayOfWeek>();
  int _dayOfMonth;
  List<int> _validDaysOfMonth = List<int>();
  MonthOfYear _monthOfYear;
  WeekNumber _weekOfMonth;
  DayOfWeek _selectedDayOfWeek = DayOfWeek.Monday;
/*   Availability _availability = Availability.Busy; */

  List<Attendee> _attendees = <Attendee>[];
  List<Reminder> _reminders = <Reminder>[];

  String companyName;

  _CalendarEventPageState(
      this._calendar, this._event, this._recurringEventDialog) {
    _deviceCalendarPlugin = DeviceCalendarPlugin();

    _attendees = <Attendee>[];
    _reminders = <Reminder>[];
    _recurrenceRuleEndType = RecurrenceRuleEndType.Indefinite;

    if (_event == null) {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(Duration(hours: 1));
      _event = Event(_calendar.id, start: _startDate, end: _endDate);

      _recurrenceEndDate = _endDate;
      _dayOfMonth = 1;
      _monthOfYear = MonthOfYear.January;
      _weekOfMonth = WeekNumber.First;
      /*    _availability = Availability.Busy; */
    } else {
      _startDate = _event.start;
      _endDate = _event.end;
      _isRecurringEvent = _event.recurrenceRule != null;

      if (_event.attendees.isNotEmpty) {
        _attendees.addAll(_event.attendees);
      }

      if (_event.reminders.isNotEmpty) {
        _reminders.addAll(_event.reminders);
      }

      if (_isRecurringEvent) {
        _interval = _event.recurrenceRule.interval;
        _totalOccurrences = _event.recurrenceRule.totalOccurrences;
        _recurrenceFrequency = _event.recurrenceRule.recurrenceFrequency;

        if (_totalOccurrences != null) {
          _recurrenceRuleEndType = RecurrenceRuleEndType.MaxOccurrences;
        }

        if (_event.recurrenceRule.endDate != null) {
          _recurrenceRuleEndType = RecurrenceRuleEndType.SpecifiedEndDate;
          _recurrenceEndDate = _event.recurrenceRule.endDate;
        }

        _isByDayOfMonth = _event.recurrenceRule.weekOfMonth == null;
        _daysOfWeek = _event.recurrenceRule.daysOfWeek ?? <DayOfWeek>[];
        _monthOfYear = _event.recurrenceRule.monthOfYear ?? MonthOfYear.January;
        _weekOfMonth = _event.recurrenceRule.weekOfMonth ?? WeekNumber.First;
        _selectedDayOfWeek =
            _daysOfWeek.isNotEmpty ? _daysOfWeek.first : DayOfWeek.Monday;
        _dayOfMonth = _event.recurrenceRule.dayOfMonth ?? 1;

        if (_daysOfWeek.isNotEmpty) {
          _updateDaysOfWeekGroup();
        }
      }

      /*  _availability = _event.availability; */
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

    // Getting days of the current month (or a selected month for the yearly recurrence) as a default
    _getValidDaysOfMonth(_recurrenceFrequency);
  }

/*   void printAttendeeDetails(Attendee attendee) {
    print(
        'attendee name: ${attendee.name}, email address: ${attendee.emailAddress}, type: ${attendee.iosAttendeeDetails?.role?.enumToString}');
    print(
        'ios specifics - status: ${attendee.iosAttendeeDetails?.attendanceStatus}, type: ${attendee.iosAttendeeDetails?.role?.enumToString}');
    print(
        'android specifics - status ${attendee.androidAttendeeDetails?.attendanceStatus}, type: ${attendee.androidAttendeeDetails?.role?.enumToString}');
  } */

  UserViewModel _userViewModel;
  MeetingViewModel _meetingViewModel;
  @override
  void initState() {
    super.initState();
    /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp){
    _
  }), */
    getRoom();
  }

  String dropdownValue;
  String salon;
  List<Users> _liste = [];
  getRoom() async {
    // ignore: await_only_futures
    _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    _meetingViewModel =
        // ignore: await_only_futures
        await Provider.of<MeetingViewModel>(context, listen: false);
    await _userViewModel.getMeetingRoom(_userViewModel.getToken);
    /* await _meetingRoomViewModel.getMeetingRoom(_userViewModel.getToken); */
    // ignore: await_only_futures
    await _userViewModel.getRoom.map((room) {
      if (room.toplantiOdasiMi && room.toplantiSalonAdi != null) {
        _liste.add(
            new Users(id: room.id, toplantiSalonAdi: room.toplantiSalonAdi));
      }
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_event.eventId?.isEmpty ?? true
            ? 'Toplantı Oluştur'
            : _calendar.isReadOnly
                ? 'View event ${_event.title}'
                : '${_event.title}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: AbsorbPointer(
            absorbing: _calendar.isReadOnly,
            child: Column(
              children: [
                Form(
                  autovalidate: _autovalidate,
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          key: Key('titleField'),
                          initialValue: _event.title,
                          decoration: const InputDecoration(
                            labelText: 'Başlık',
                          ),
                          validator: _validateTitle,
                          onSaved: (String value) {
                            _event.title = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: _event.description,
                          decoration: const InputDecoration(
                            labelText: 'subject',
                          ),
                          onSaved: (String value) {
                            _event.description = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: companyName,
                          decoration: const InputDecoration(
                            labelText: 'Firma Adı',
                          ),
                          onSaved: (String value) {
                            companyName = value;
                          },
                        ),
                      ),

                      _liste.isEmpty
                          ? CircularProgressIndicator()
                          : Container(
                              padding: const EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: salon,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    /*  style: TextStyle(color: Colors.deepPurple), */
                                    underline: Container(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    hint: Text("Toplanti Salonu Seçiniz"),
                                    onChanged: (newValue) {
                                      _userViewModel.getRoom.map((room) {
                                        if (newValue == room.id) {
                                          _event.location =
                                              room.toplantiSalonAdi;
                                        }
                                      }).toList();
                                      setState(() {
                                        salon = newValue;
                                      });
                                    },
                                    items: _liste.map((room) {
                                      return DropdownMenuItem(
                                        child: Text(room.toplantiSalonAdi),
                                        value: room.id,
                                      );
                                    }).toList()),
                              ),
                            ),
                      //-----------------------------------------------------------------
                      /*  Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: _event.location,
                          decoration: const InputDecoration(
                            labelText: 'Toplantı Salonu',
                          ),
                          onSaved: (String value) {
                            _event.location = value;
                          },
                        ),
                      ), */
                      //-------------------------------------------------------------
                      /*    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          initialValue: _event.url?.data?.contentText ?? '',
                          decoration: const InputDecoration(
                              labelText: 'URL', hintText: 'https://google.com'),
                          onSaved: (String value) {
                            var uri = Uri.dataFromString(value);
                            _event.url = uri;
                          },
                        ),
                      ), */
                      /*   ListTile(
                        leading: Text(
                          'Availability',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: DropdownButton<Availability>(
                          value: _availability,
                          onChanged: (Availability newValue) {
                            setState(() {
                              _availability = newValue;
                              _event.availability = newValue;
                            });
                          },
                          items: Availability.values
                              .map<DropdownMenuItem<Availability>>(
                                  (Availability value) {
                            return DropdownMenuItem<Availability>(
                              value: value,
                              child: Text(value.enumToString ?? ''),
                            );
                          }).toList(),
                        ),
                      ), */
                      /*  SwitchListTile(
                        value: _event.allDay,
                        onChanged: (value) =>
                            setState(() => _event.allDay = value),
                        title: Text('Tüm gün'),
                      ), */
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DateTimePicker(
                          labelText: 'Başlangıç Tarihi',
                          enableTime: !_event.allDay,
                          selectedDate: _startDate,
                          selectedTime: _startTime,
                          selectDate: (DateTime date) {
                            setState(() {
                              _startDate = date;
                              _event.start =
                                  _combineDateWithTime(_startDate, _startTime);
                            });
                          },
                          selectTime: (TimeOfDay time) {
                            setState(
                              () {
                                _startTime = time;
                                _event.start = _combineDateWithTime(
                                    _startDate, _startTime);
                              },
                            );
                          },
                        ),
                      ),
                      if (!_event.allDay) ...[
                        if (Platform.isAndroid)
                          /* Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              initialValue: _event.start.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Start date time zone',
                                  hintText: 'Australia/Sydney'),
                              onSaved: (String value) {
                                _event.start = DateTime.parse(value);
                              },
                            ),
                          ), */
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DateTimePicker(
                              labelText: 'Bitiş Tarihi',
                              selectedDate: _endDate,
                              selectedTime: _endTime,
                              selectDate: (DateTime date) {
                                setState(
                                  () {
                                    _endDate = date;
                                    _event.end = _combineDateWithTime(
                                        _endDate, _endTime);
                                  },
                                );
                              },
                              selectTime: (TimeOfDay time) {
                                setState(
                                  () {
                                    _endTime = time;
                                    _event.end = _combineDateWithTime(
                                        _endDate, _endTime);
                                  },
                                );
                              },
                            ),
                          ),
                        /*  Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                              initialValue: Platform.isAndroid
                                  ? _event.end.toString()
                                  : _event.start.toString(),
                              decoration: InputDecoration(
                                  labelText: Platform.isAndroid
                                      ? 'End date time zone'
                                      : 'Start and end time zone',
                                  hintText: 'Australia/Sydney'),
                              onSaved: (String value) => Platform.isAndroid
                                  ? _event.end = DateTime.parse(value)
                                  : _event.start = DateTime.parse(value)),
                        ), */
                      ],
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventAttendeePage()));
                          if (result == null) return;

                          _attendees.add(result);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10.0,
                              children: [
                                Icon(Icons.people),
                                Text(!_calendar.isReadOnly
                                    ? 'Katılımcı Ekle'
                                    : 'Katılımcılar')
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _attendees.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: _attendees[index].isOrganiser
                                ? Colors.greenAccent[100]
                                : Colors.transparent,
                            child: ListTile(
                              title: GestureDetector(
                                  child:
                                      Text('${_attendees[index].emailAddress}'),
                                  onTap: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventAttendeePage(
                                                    attendee:
                                                        _attendees[index])));
                                    if (result == null) return;
                                    _attendees[index] = result;
                                  }),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueAccent)),
                                    child: Text(
                                        '${_attendees[index].role.enumToString}'),
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        _attendees.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.redAccent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventRemindersPage(_reminders)));
                          if (result == null) {
                            return;
                          }
                          _reminders = result;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10.0,
                              children: [
                                Icon(Icons.alarm),
                                if (_reminders.isEmpty)
                                  Text(!_calendar.isReadOnly
                                      ? 'Hatırlatma Ekle'
                                      : 'Hatırlatıcılar'),
                                for (var reminder in _reminders)
                                  Text('${reminder.minutes} dakika önce ; ')
                              ],
                            ),
                          ),
                        ),
                      ),
                      /* is recurring */
                    ],
                  ),
                ),
                if (!_calendar.isReadOnly &&
                    (_event.eventId?.isNotEmpty ?? false)) ...[
                  RaisedButton(
                    key: Key('deleteEventButton'),
                    textColor: Colors.white,
                    color: Colors.red,
                    child: Text('Sil'),
                    onPressed: () async {
                      var result = true;
                      if (!_isRecurringEvent) {
                        _meetingViewModel.deleteMeeting(
                            _userViewModel.getToken, _event.eventId);
                        await _deviceCalendarPlugin.deleteEvent(
                            _calendar.id, _event.eventId);
                      } else {
                        result = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return _recurringEventDialog;
                            });
                      }

                      if (result) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !_calendar.isReadOnly,
        child: FloatingActionButton(
          key: Key('saveEventButton'),
          onPressed: () async {
            final form = _formKey.currentState;
            if (!form.validate()) {
              _autovalidate = true; // Start validating on every change.
              showInSnackBar('Please fix the errors in red before submitting.');
            } else {
              form.save();
              if (_isRecurringEvent) {
                if (!_isByDayOfMonth &&
                    (_recurrenceFrequency == RecurrenceFrequency.Monthly ||
                        _recurrenceFrequency == RecurrenceFrequency.Yearly)) {
                  // Setting day of the week parameters for WeekNumber to avoid clashing with the weekly recurrence values
                  _daysOfWeek.clear();
                  _daysOfWeek.add(_selectedDayOfWeek);
                } else {
                  _weekOfMonth = null;
                }

                _event.recurrenceRule = RecurrenceRule(_recurrenceFrequency,
                    interval: _interval,
                    totalOccurrences: _totalOccurrences,
                    endDate: _recurrenceRuleEndType ==
                            RecurrenceRuleEndType.SpecifiedEndDate
                        ? _recurrenceEndDate
                        : null,
                    daysOfWeek: _daysOfWeek,
                    dayOfMonth: _dayOfMonth,
                    monthOfYear: _monthOfYear,
                    weekOfMonth: _weekOfMonth);
              }

              _event.attendees = _attendees;
              _event.reminders = _reminders;
              /*       _event.availability = _availability; */
              var createEventResult =
                  await _deviceCalendarPlugin.createOrUpdateEvent(_event);
              if (createEventResult.isSuccess) {
                Navigator.pop(context, true);
              } else {
                /*  showInSnackBar(createEventResult.errors
                    .map((err) => '[${err.errorCode}] ${err.errorMessage}')
                    .join(' | ')); */
              }
            }

            await _meetingViewModel.setMeeting(
                _userViewModel.getToken,
                _userViewModel.getUser.email,
                companyName,
                _event.title,
                _event.description,
                salon,
                _event.start.toString(),
                _event.end.toString(),
                _attendees);
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  Text _recurrenceFrequencyToText(RecurrenceFrequency recurrenceFrequency) {
    switch (recurrenceFrequency) {
      case RecurrenceFrequency.Daily:
        return Text('Daily');
      case RecurrenceFrequency.Weekly:
        return Text('Weekly');
      case RecurrenceFrequency.Monthly:
        return Text('Monthly');
      case RecurrenceFrequency.Yearly:
        return Text('Yearly');
      default:
        return Text('');
    }
  }

  Text _recurrenceFrequencyToIntervalText(
      RecurrenceFrequency recurrenceFrequency) {
    switch (recurrenceFrequency) {
      case RecurrenceFrequency.Daily:
        return Text(' Day(s)');
      case RecurrenceFrequency.Weekly:
        return Text(' Week(s) on');
      case RecurrenceFrequency.Monthly:
        return Text(' Month(s)');
      case RecurrenceFrequency.Yearly:
        return Text(' Year(s)');
      default:
        return Text('');
    }
  }

  Text _recurrenceRuleEndTypeToText(RecurrenceRuleEndType endType) {
    switch (endType) {
      case RecurrenceRuleEndType.Indefinite:
        return Text('Indefinitely');
      case RecurrenceRuleEndType.MaxOccurrences:
        return Text('After a set number of times');
      case RecurrenceRuleEndType.SpecifiedEndDate:
        return Text('Continues until a specified date');
      default:
        return Text('');
    }
  }

  // Get total days of a month
  void _getValidDaysOfMonth(RecurrenceFrequency frequency) {
    _validDaysOfMonth.clear();
    var totalDays = 0;

    // Year frequency: Get total days of the selected month
    if (frequency == RecurrenceFrequency.Yearly) {
      totalDays = DateTime(DateTime.now().year, _monthOfYear.value + 1, 0).day;
    } else {
      // Otherwise, get total days of the current month
      var now = DateTime.now();
      totalDays = DateTime(now.year, now.month + 1, 0).day;
    }

    for (var i = 1; i <= totalDays; i++) {
      _validDaysOfMonth.add(i);
    }
  }

  void _updateDaysOfWeek() {
    var days = _dayOfWeekGroup.getDays;

    switch (_dayOfWeekGroup) {
      case DayOfWeekGroup.Weekday:
      case DayOfWeekGroup.Weekend:
      case DayOfWeekGroup.AllDays:
        _daysOfWeek.clear();
        _daysOfWeek.addAll(days.where((a) => _daysOfWeek.every((b) => a != b)));
        break;
      case DayOfWeekGroup.None:
        _daysOfWeek.clear();
        break;
    }
  }

  void _updateDaysOfWeekGroup({DayOfWeek selectedDay}) {
    var deepEquality = const DeepCollectionEquality.unordered().equals;

    // If _daysOfWeek contains nothing
    if (_daysOfWeek.isEmpty && _dayOfWeekGroup != DayOfWeekGroup.None) {
      _dayOfWeekGroup = DayOfWeekGroup.None;
    }
    // If _daysOfWeek contains Monday to Friday
    else if (deepEquality(_daysOfWeek, DayOfWeekGroup.Weekday.getDays) &&
        _dayOfWeekGroup != DayOfWeekGroup.Weekday) {
      _dayOfWeekGroup = DayOfWeekGroup.Weekday;
    }
    // If _daysOfWeek contains Saturday and Sunday
    else if (deepEquality(_daysOfWeek, DayOfWeekGroup.Weekend.getDays) &&
        _dayOfWeekGroup != DayOfWeekGroup.Weekend) {
      _dayOfWeekGroup = DayOfWeekGroup.Weekend;
    }
    // If _daysOfWeek contains all days
    else if (deepEquality(_daysOfWeek, DayOfWeekGroup.AllDays.getDays) &&
        _dayOfWeekGroup != DayOfWeekGroup.AllDays) {
      _dayOfWeekGroup = DayOfWeekGroup.AllDays;
    }
    // Otherwise null
    else {
      _dayOfWeekGroup = null;
    }
  }

  String _validateTotalOccurrences(String value) {
    if (value.isNotEmpty && int.tryParse(value) == null) {
      return 'Total occurrences needs to be a valid number';
    }
    return null;
  }

  String _validateInterval(String value) {
    if (value.isNotEmpty && int.tryParse(value) == null) {
      return 'Interval needs to be a valid number';
    }
    return null;
  }

  String _validateTitle(String value) {
    if (value.isEmpty) {
      return 'Name is required.';
    }

    return null;
  }

  DateTime _combineDateWithTime(DateTime date, TimeOfDay time) {
    if (date == null && time == null) {
      return null;
    }
    final dateWithoutTime =
        DateTime.parse(DateFormat('y-MM-dd 00:00:00').format(date));
    return dateWithoutTime
        .add(Duration(hours: time.hour, minutes: time.minute));
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
