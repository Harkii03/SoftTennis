import 'package:flutter/material.dart';
import 'package:tennis/Record_page.dart';
import 'package:tennis/Event_page.dart';
import 'package:tennis/Video_page.dart';
import 'package:tennis/Login_page.dart';

import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

// 会津若松体育施設予約のURL
final Uri _url = Uri.parse('https://reserve.city.aizuwakamatsu.fukushima.jp/');

// 予約ページに遷移する処理
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

DateTime _focused = DateTime.now();
DateTime? _selected;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  //仮のデータ
  final sampleEvents = {
    DateTime.utc(2023, 8, 3): ['firstEvent', 'secodnEvent'],
    DateTime.utc(2023, 8, 5): ['thirdEvent', 'fourthEvent']
  };
  List<String> _selectedEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ソフトテニス管理アプリ",
              style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
          backgroundColor: const Color.fromARGB(173, 49, 44, 44),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => EventPage()),
                );
              },
              child: const Text("イベントを追加",
                  style: TextStyle(
                    color: Color.fromARGB(246, 222, 222, 222),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.0,
                    decoration: TextDecoration.underline,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2022, 4, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              locale: 'ja_JP',
              eventLoader: (date) {
                return sampleEvents[date] ?? [];
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selected, day);
              },
              onDaySelected: (selected, focused) {
                if (!isSameDay(_selected, selected)) {
                  setState(() {
                    _selected = selected;
                    _focused = focused;
                    _selectedEvents = sampleEvents[selected] ?? [];
                  });
                }
              },
              focusedDay: _focused,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = _selectedEvents[index];
                  return Card(
                    child: ListTile(
                      title: Text(event),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(246, 241, 205, 172),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 200,
              height: 70,
              child: OutlinedButton(
                child: const Text('コートの予約'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  // 予約ページに遷移する処理
                  // 'https://reserve.city.aizuwakamatsu.fukushima.jp/' に飛ぶ
                  _launchUrl();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(246, 241, 205, 172),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 200,
              height: 70,
              child: OutlinedButton(
                child: const Text('ログアウト'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () async {
                  // ログアウト処理
                  // 内部で保持しているログイン情報等が初期化される
                  // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                  await FirebaseAuth.instance.signOut();
                  // ログイン画面に遷移＋チャット画面を破棄
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: '記録',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_call),
              label: '動画',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => MyHomePage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => RecordPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => VideoPage()),
                );
                break;
            }
          },
        ));
  }
}
