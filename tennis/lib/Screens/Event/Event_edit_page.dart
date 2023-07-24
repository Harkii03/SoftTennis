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
  String _infotext = '';

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.event;
  }

  void _updateEventInFirestore(String updatedEventName) {
    // イベントドキュメントのコレクションへの参照を取得
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

    // イベントドキュメントへの参照を取得
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc(widget.event);

    // eventNameが"test"と一致するドキュメントを検索
    eventsCollection
        .where('eventName', isEqualTo: eventRef.id)
        .get()
        .then((querySnapshot) {
      // 一致するドキュメントがあるかどうかチェック
      if (querySnapshot.docs.isNotEmpty) {
        // 一致するドキュメントが見つかった場合は、最初のドキュメントを取得して更新
        DocumentReference eventRef = querySnapshot.docs.first.reference;
        eventRef.update({'eventName': updatedEventName}).then((_) {
          print("Event name updated in Firestore");
          // 必要に応じて、ユーザーに成功したことを示すメッセージを表示できます。
          setState(() {
            _infotext = '更新しました';
          });

          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(
              context,
            ).pop(updatedEventName);
          });
        }).catchError((error) {
          print("Error updating event name: $error");
          // 必要に応じて、ユーザーにエラーを示すメッセージを表示できます。
        });
      } else {
        print("Error: Document not found.");
        // 必要に応じて、ユーザーにエラーを示すメッセージを表示できます。
      }
    }).catchError((error) {
      print("Error retrieving event document: $error");
      // 必要に応じて、ユーザーにエラーを示すメッセージを表示できます。
    });
  }

  void _deleteEventFromFirestore() {
    // イベントドキュメントのコレクションへの参照を取得
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

    // イベントドキュメントへの参照を取得
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc(widget.event);

    // eventNameフィールドが"test"と一致するドキュメントを検索
    eventsCollection
        .where('eventName', isEqualTo: eventRef.id)
        .get()
        .then((querySnapshot) {
      // 一致するドキュメントがあるかどうかチェック
      if (querySnapshot.docs.isNotEmpty) {
        // 一致するドキュメントが見つかった場合は、最初のドキュメントを取得して削除
        DocumentReference eventRef = querySnapshot.docs.first.reference;
        eventRef.delete().then((_) {
          print("Event deleted from Firestore");

          setState(() {
            _infotext = '削除しました';
          });

          // 削除したことを伝えて、前の画面に戻る
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(
              context,
            ).pop('deleted');
          });
        }).catchError((error) {
          print("Error deleting event: $error");
        });
      } else {
        // 一致するドキュメントが見つからなかった場合は、エラーメッセージを表示
        print("Error: Document not found.");
        // 必要に応じて、ユーザーにエラーを示すメッセージを表示できます。
      }
    }).catchError((error) {
      print("Error retrieving event document: $error");
      // 必要に応じて、ユーザーにエラーを示すメッセージを表示できます。
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
            SizedBox(height: 16),
            Text(_infotext),
          ],
        ),
      ),
    );
  }
}
