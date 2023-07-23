import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeRecordPage extends StatefulWidget {
  @override
  _PracticeRecordPageState createState() => _PracticeRecordPageState();
}

class _PracticeRecordPageState extends State<PracticeRecordPage> {
  String _infoText = '';
  DateTime _startDate = DateTime.now(); // 初期値を現在の日付に設定

  // Place these declarations at the top of your _PracticeRecordPageState class
  TextEditingController _reflectionController = TextEditingController();
  TextEditingController _taskController = TextEditingController();

  void _saveRecordToFirestore(String date, String reflection, String task) {
    FirebaseFirestore.instance.collection('practice_records').add({
      'date': date,
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
        title: Text('記録',
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

            Container(
              child: Text('反省'),
            ),
            Container(
              // Rectangular Text Form Field for "反省"
              padding: EdgeInsets.symmetric(horizontal: 16),
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
            Container(
              child: Text('課題'),
            ),
            Container(
              // Rectangular Text Form Field for "課題"
              padding: EdgeInsets.symmetric(horizontal: 16),
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
              //記録を追加するボタン
              child: ElevatedButton(
                onPressed: () {
                  // Get the values from the text fields
                  String date = DateFormat('yyyy-MM-dd').format(_startDate);
                  String reflection = _reflectionController.text;
                  String task = _taskController.text;

                  // Save the data to Firestore
                  _saveRecordToFirestore(date, reflection, task);
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
