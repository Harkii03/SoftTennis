import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennis/Login/Login_page.dart';
import 'package:tennis/Screens/Event/Event_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

// 会津若松体育施設予約のURL
final Uri _url = Uri.parse('https://reserve.city.aizuwakamatsu.fukushima.jp/');

DateTime _focused = DateTime.now();
DateTime? _selected;

// 予約ページに遷移する処理
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Map<DateTime, List<String>> _eventsData = {};
  List<String> _selectedEvents = [];

  // Function to fetch events data from Firestore
  Future<void> _fetchEventsData() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('events').get();

      Map<DateTime, List<String>> eventsData = {};

      snapshot.docs.forEach((doc) {
        DateTime eventDate = (doc['eventDate'] as Timestamp).toDate();
        String eventName = doc['eventName'];

        // Check if the eventDate already exists in the map
        if (eventsData.containsKey(eventDate)) {
          eventsData[eventDate]!.add(eventName);
        } else {
          eventsData[eventDate] = [eventName];
          //print(eventsData[eventDate]);
        }
      });

      setState(() {
        _eventsData = eventsData;
        _selectedEvents = _eventsData[_selected] ?? [];
      });
    } catch (e) {
      print('Error fetching events data: $e');
    }
  }

  Color _textColor(DateTime day) {
    const _defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return _defaultTextColor;
  }

  bool _isLoading = true;

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
      body: Container(
        color: const Color.fromARGB(196, 243, 228, 210),
        child: Column(
          children: [
            // カレンダーウィジェット
            // Show loading indicator while fetching data
            _isLoading
                ? CircularProgressIndicator()
                : TableCalendar(
                    firstDay: DateTime.utc(2020, 4, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    locale: 'ja_JP',
                    eventLoader: (date) {
                      print(_eventsData);
                      return _eventsData[date] ?? [];
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false, // "2weeks" テキストを非表示にする
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selected, day);
                    },
                    onDaySelected: (selected, focused) {
                      if (!isSameDay(_selected, selected)) {
                        setState(() {
                          _selected = selected;
                          _focused = focused;
                          _selectedEvents = _eventsData[selected] ?? [];
                        });
                      }
                    },
                    focusedDay: _focused,
                    calendarBuilders: CalendarBuilders(
                      // 日付セルのテキストスタイルをカスタマイズ
                      defaultBuilder: (context, date, _) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent, // 背景を透明にする
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _textColor(date), // _textColor 関数を適用
                            ),
                          ),
                        );
                      },
                      // 選択中の日付セルのテキストスタイルをカスタマイズ
                      selectedBuilder: (context, date, _) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor, // 選択時の背景色
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white, // 選択時のテキスト色
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            // イベントリスト
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
                  color: const Color.fromARGB(246, 241, 205, 172),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 200,
              height: 70,
              child: OutlinedButton(
                child: Text('コートの予約'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  // 予約ページに遷移する処理
                  _launchUrl();
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: const Color.fromARGB(173, 49, 44, 44)),
              child: Text('Application inforrmation'),
            ),
            ListTile(
              title: Text('Log out'),
              onTap: () async {
                // ログアウト処理
                // 内部で保持しているログイン情報等が初期化される
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Fetch events data when the widget is initialized
    _fetchEventsData().then((_) {
      setState(() {
        _isLoading = false; // Set loading flag to false when data is fetched
      });
    });
  }
}
