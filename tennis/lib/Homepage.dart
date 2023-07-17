import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime _focused = DateTime.now();
DateTime? _selected;

class EventModel {
  final DateTime date;
  final String title;

  EventModel({required this.date, required this.title});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  //イベントのリストア
  List<EventModel> events = [
    EventModel(date: DateTime(2023, 6, 1), title: 'イベント1'),
    EventModel(date: DateTime(2023, 6, 5), title: 'イベント2'),
    EventModel(date: DateTime(2023, 6, 15), title: 'イベント3'),
    // 他のイベントを追加...
  ];
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム画面', style: TextStyle(color: Colors.grey)),
        backgroundColor: Color.fromARGB(215, 255, 255, 255),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            //縁取り
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(235, 243, 143, 51),
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 395.0,
              //カレンダ0の表示
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 4, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                selectedDayPredicate: (day) {
                  return isSameDay(_selected, day);
                },
                onDaySelected: (selected, focused) {
                  if (!isSameDay(_selected, selected)) {
                    setState(() {
                      _selected = selected;
                      _focused = focused;
                    });
                  }
                },
                focusedDay: _focused,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // 枠線
                        border: Border.all(color: Colors.blue, width: 2),
                        // 角丸
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 200,
                      height: 70,
                      child: OutlinedButton(
                        child: const Text('記録'),
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    //余白
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        // 枠線
                        border: Border.all(color: Colors.blue, width: 2),
                        // 角丸
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 200,
                      height: 70,
                      child: ElevatedButton(
                        child: const Text('反省'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[300],
                          onPrimary: Colors.purple,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    //余白
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        // 枠線
                        border: Border.all(color: Colors.blue, width: 2),
                        // 角丸
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 200,
                      height: 70,
                      child: OutlinedButton(
                        child: const Text('動画'),
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: 150,
                  height: 230,
                  decoration: BoxDecoration(
                    // 枠線
                    border: Border.all(color: Colors.blue, width: 2),
                    // 角丸
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Color.fromARGB(252, 251, 150, 79),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   padding: const EdgeInsets.all(3.0),
          //   child: Text(
          //     'My Calendar',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 24.0,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}