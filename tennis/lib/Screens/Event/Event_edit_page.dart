import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventPage extends StatefulWidget {
  final String event;

  EditEventPage({required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.event;
  }

  void _updateEventInFirestore(String updatedEventName) {
    // Get the current event document reference from Firestore
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc(widget.event);

    // Check if the document exists before updating
    eventRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // Document exists, proceed with the update
        eventRef.update({'eventName': updatedEventName}).then((_) {
          print("Event name updated in Firestore");
          // Optionally, you can show a message to the user indicating successful update.
        }).catchError((error) {
          print("Error updating event name: $error");
          // Optionally, you can show a message to the user indicating the error.
        });
      } else {
        // Document does not exist, handle the error accordingly
        print("Error: Document does not exist.");
        // You can choose to create a new document here if desired or show an error message.
      }
    }).catchError((error) {
      print("Error checking document existence: $error");
      // Optionally, you can show a message to the user indicating the error.
    });
  }

  void _deleteEventFromFirestore() {
    // イベントドキュメントへの参照を取得
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc(widget.event);

    // ドキュメントを削除
    eventRef.delete().then((_) {
      print("Event deleted from Firestore");
      // Optionally, you can show a message to the user indicating successful deletion.
      // 削除が成功したことをユーザーに示すメッセージを表示することもできます。

      // 削除したことを伝えて、前の画面に戻る
      Navigator.pop(context, 'deleted');
    }).catchError((error) {
      print("Error deleting event: $error");
      // Optionally, you can show a message to the user indicating the error.
      // エラーが発生したことをユーザーに示すメッセージを表示することもできます。
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編集ページ',
            style: TextStyle(
                color: Color.fromARGB(246, 241, 205, 172), fontSize: 19.0)),
        backgroundColor: const Color.fromARGB(173, 49, 44, 44),
      ),
      body: Container(
        color: const Color.fromARGB(196, 243, 228, 210),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'イベントの名前',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Get the updated event name from the text field
                String updatedEventName = _textEditingController.text;
                // Update the event name in Firestore
                _updateEventInFirestore(updatedEventName);
                // Save changes and return to the previous screen
                Navigator.pop(context, updatedEventName);
              },
              child: Text('  保存  '),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Delete the event from Firestore
                _deleteEventFromFirestore();
              },
              child: Text('  削除  '),
            ),
          ],
        ),
      ),
    );
  }
}
