import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();

  DateTime? _startDate;

  String _infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント追加",
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: const Color.fromARGB(173, 49, 44, 44),
      ),
      body: Container(
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
              // ... Existing TextFormField widgets ...

              // Button to select start date
              ElevatedButton(
                onPressed: _selectStartDate,
                child: Text(_startDate != null
                    ? '日付: ${_startDate?.toLocal()}'
                    : '開始日を選択'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent, // Update onPressed to call _saveEvent
                child: Text('イベントを追加'),
              ),
              // メッセージ表示用のテキストウィジェット
              Text(_infoText),
            ],
          ),
        ),
      ),
    );
  }

  void _selectStartDate() {
    DatePicker.showDatePicker(
      context,
      currentTime: _startDate ?? DateTime.now(),
      minTime: DateTime(2021),
      maxTime: DateTime(2030),
      onConfirm: (DateTime picked) {
        if (picked != null) {
          setState(() {
            _startDate = picked;
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

      // Save the event data to Firestore

      await newEventRef.set({
        'userId': userId,
        'eventName': _eventNameController.text, // Use directly from form fields
        'eventDescription':
            _eventDescriptionController.text, // Use directly from form fields
        'startDate': _startDate,
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
}