import 'package:flutter/material.dart';
import 'package:tennis/Screens/Record/App_View_practice_record_page.dart';
import 'package:tennis/Screens/Record/Practice_record_page.dart';
import 'package:tennis/Screens/Record/Tournament_record_page.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // タイトルz
        title: const Text(
          '記録ページ',
          style: TextStyle(color: Color.fromARGB(246, 241, 205, 172)),
        ),
        // 背景色
        backgroundColor: const Color.fromARGB(173, 49, 44, 44),
      ),
      body: Container(
        color: const Color.fromARGB(196, 243, 228, 210),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      // 角丸
                      borderRadius: BorderRadius.circular(60),
                      // 枠線
                      border: Border.all(
                        color: const Color.fromARGB(173, 49, 44, 44),
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                PracticeRecordPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          '練習記録',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      // 角丸
                      borderRadius: BorderRadius.circular(60),
                      // 枠線
                      border: Border.all(
                        color: const Color.fromARGB(173, 49, 44, 44),
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                TournamentRecordPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          '大会記録',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Container(
                width: 180,
                height: 60,
                decoration: BoxDecoration(
                  // 枠線
                  border: Border.all(
                    color: const Color.fromARGB(173, 49, 44, 44),
                    width: 2,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AppRecordViewPage(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      '記録一覧',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
