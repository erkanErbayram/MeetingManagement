import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';

class EventAttendeePage extends StatefulWidget {
  final Attendee attendee;
  const EventAttendeePage({Key key, this.attendee}) : super(key: key);

  @override
  _EventAttendeePageState createState() => _EventAttendeePageState(attendee);
}

class _EventAttendeePageState extends State<EventAttendeePage> {
  Attendee _attendee;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailAddressController = TextEditingController();
  var _role = AttendeeRole.Optional;

  _EventAttendeePageState(Attendee attendee) {
    if (attendee != null) {
      _attendee = attendee;
      _nameController.text = _attendee.name;
      _emailAddressController.text = _attendee.emailAddress;
      _role = _attendee.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_attendee != null
            ? 'Guncelle ${_attendee.name}'
            : 'Katılımcı Ekle'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ad Soyad giriniz.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Ad Soyad'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailAddressController,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Geçerli bir e-mail giriniz.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ),
               /*  ListTile(
                  leading: Text('Katılım'),
                  trailing: DropdownButton<AttendeeRole>(
                    onChanged: (value) {
                      setState(() {
                        _role = value;
                      });
                    },
                    value: _role,
                    items: AttendeeRole.values
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.enumToString),
                            ))
                        .toList(),
                  ),
                ), */
              ],
            ),
          ),
          RaisedButton(
            child: Text('Ekle'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  _attendee = Attendee(
                    name: _nameController.text,
                    emailAddress: _emailAddressController.text,
                    role: _role,
                  );
                  _emailAddressController.clear();
                });
                Navigator.pop(context, _attendee);
              }
            },
          )
        ],
      ),
    );
  }
}
