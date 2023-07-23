import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:tennis/Screens/Event/Event_edit_page.dart';

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();

  int _selectedHour = 0; // 追加: 選択した時間を格納する変数
  int _selectedMinute = 0; // 追加: 選択した分を格納する変数

  DateTime? _startDate;

  String _infoText = '';

  String formatDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  void _selectStartDate() {
    DatePicker.showDatePicker(
      context,
      currentTime: _startDate ?? DateTime.now(),
      minTime: DateTime(2021),
      maxTime: DateTime(2030),
      locale: LocaleType.jp, // Set the locale for Japanese format
      onConfirm: (DateTime picked) {
        if (picked != null) {
          setState(() {
            _startDate = picked;
          });
        }
      },
    );
  }

  // 追加: 時間を選択するための関数
  void _selectTime() {
    DatePicker.showPicker(
      context,
      showTitleActions: true,
      pickerModel: TimePickerModel(),
      onConfirm: (time) {
        if (time != null) {
          setState(() {
            _selectedHour = time.hour;
            _selectedMinute = time.minute;
          });
        }
      },
    );
  }

  void _saveEvent() async {
    try {
      // Access the "events" collection in Firestore
      CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('events');

      // Create a new event document with a unique ID
      DocumentReference newEventRef = eventsCollection.doc();

      // Get the current user's ID
      var _user = FirebaseAuth.instance.currentUser;
      String userId = _user?.uid.toString() ?? '';

      // Format the _startDate to "YYYY-MM-DD" before saving to Firestore
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(_startDate ?? DateTime.now());

      // Update the event data in Firestore with a unique name (e.g., using timestamp)
      String uniqueEventName = DateTime.now().toIso8601String();

      await newEventRef.set({
        'userId': userId,
        'eventName': _eventNameController.text,
        'eventDescription': _eventDescriptionController.text,
        'eventDate': formattedDate, // Save the formatted date
        'eventNameUnique': uniqueEventName, // Add the unique event name
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _infoText = 'イベントを追加しました';
      });

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      // Handle any errors that occurred during saving
      print('Error saving event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント追加",
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: const Color.fromARGB(173, 49, 44, 44),
      ),
      body: Container(
        color: Color.fromARGB(196, 243, 228, 210),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: 'イベント名'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'イベント名を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: const InputDecoration(labelText: 'イベントの説明'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'イベントの説明を入力してください';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Button to select start date
              ElevatedButton(
                onPressed: _selectStartDate,
                child: Text(
                  _startDate != null ? '日付: ${formatDate(_startDate!)}' : '日時',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent, // Update onPressed to call _saveEvent
                child: const Text('イベントを追加'),
              ),
              // メッセージ表示用のテキストウィジェット
              Text(_infoText),
            ],
          ),
        ),
      ),
    );
  }
}
