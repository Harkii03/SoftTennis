import 'package:flutter/material.dart';
import 'package:tennis/Practice_Record_page.dart';
import 'package:tennis/Tournament_Record_page.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          // タイトル
          title: const Text('記録ページ',
              style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
          // 背景色
          backgroundColor: Color.fromARGB(173, 49, 44, 44),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                // 枠線
                border: Border.all(
                    color: Color.fromARGB(246, 241, 205, 172), width: 2),
                // 角丸
                borderRadius: BorderRadius.circular(8),
              ),
              width: 200,
              height: 70,
              child: OutlinedButton(
                child: const Text('練習記録'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            PracticeRecordPage()),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // 枠線
                border: Border.all(
                    color: Color.fromARGB(246, 241, 205, 172), width: 2),
                // 角丸
                borderRadius: BorderRadius.circular(8),
              ),
              width: 200,
              height: 70,
              child: OutlinedButton(
                child: const Text('大会記録'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            TournamentRecordPage()),
                  );
                },
              ),
            ),
          ],
        ));

    throw UnimplementedError();
  }
}
