import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentRecordPage extends StatefulWidget {
  @override
  _TournamentRecordPageState createState() => _TournamentRecordPageState();
}

class _TournamentRecordPageState extends State<TournamentRecordPage> {
  String _infoText = '';
  DateTime _startDate = DateTime.now(); // 初期値を現在の日付に設定

  TextEditingController _tournament_nameController = TextEditingController();
  TextEditingController _resultController = TextEditingController();
  TextEditingController _reflectionController = TextEditingController();
  TextEditingController _taskController = TextEditingController();

  void _saveRecordToFirestore(String date, String tournament_name,
      String result, String reflection, String task) {
    FirebaseFirestore.instance.collection('tournament_records').add({
      'date': date,
      'tournament_name': tournament_name,
      'result': result,
      'reflection': reflection,
      'task': task,
    }).then((value) {
      // Do something after data is successfully added (if needed)
      print("Record added to Firestore");
      setState(() {
        _infoText = 'イベントを追加しました';
      });

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      // Handle any error that occurred while adding data to Firestore
      print("Error adding record: $error");
    });
  }

  void _selectStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Use dark theme to have a better contrast
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('練習大会記録',
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: Color.fromARGB(173, 49, 44, 44),
      ),
      body: Container(
        color: const Color.fromARGB(196, 243, 228, 210),
        child: Column(
          children: [
            //日付をにゅうりょくするフォーム
            Container(
              child: Text('日付'),
            ),
            // Center the date selection widget
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: _selectStartDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_startDate),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            Text('大会名'),

            Container(
              child: TextField(
                controller: _tournament_nameController,
                decoration: InputDecoration(
                  hintText: '大会名を入力してください',
                ),
              ),
            ),

            Text('結果'),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _resultController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),

            Text('反省'),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _reflectionController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),

            Text('課題'),

            Container(
              // Rectangular Text Form Field for "課題"
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _taskController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              //テキストを入力するフォーム

              child: ElevatedButton(
                onPressed: () {
                  // Get the values from the text fields
                  String date = DateFormat('yyyy-MM-dd').format(_startDate);
                  String tournament_name = _tournament_nameController.text;
                  String result = _resultController.text;
                  String reflection = _reflectionController.text;
                  String task = _taskController.text;

                  // Save the data to Firestore
                  _saveRecordToFirestore(
                      date, tournament_name, result, reflection, task);
                },
                child: const Text('記録を追加'),
              ),
            ),
            // メッセージ表示用のテキストウィジェット
            Text(_infoText),
          ],
        ),
      ),
    );
  }
}
