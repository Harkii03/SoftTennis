import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennis/Login/Login_page.dart';
import 'package:tennis/Screens/Event/Event_edit_page.dart';
import 'package:tennis/Screens/Event/Event_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

// 会津若松体育施設予約のURL
final Uri _url = Uri.parse('https://reserve.city.aizuwakamatsu.fukushima.jp/');

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
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  DateTime Date = DateTime.now();

  final sampleMap = {};
  // カレンダーのイベントデータ
  List<String> _selectedEvents = [];
  // カレンダーのイベントデータを格納するMap
  Map<DateTime, List<String>> _eventsData = {};

  Future<void> _fetchEventsFromFirestore(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

    QuerySnapshot snapshot = await eventsCollection
        .where('eventDate', isEqualTo: formattedDate)
        .get();

    List<String> selectedEvents = [];

    snapshot.docs.forEach((doc) {
      Map<String, dynamic> eventData = doc.data()
          as Map<String, dynamic>; // Explicitly cast to the expected type
      String eventName = eventData['eventName'];
      selectedEvents.add(eventName);
    });

    _eventsData[date] = selectedEvents;

    setState(() {
      _selectedEvents =
          selectedEvents; // Update the state with the fetched events for the selected date
    });
  }

  // Function to fetch events for the currently focused month
  Future<void> _fetchEventsForCurrentMonth(DateTime focused) async {
    DateTime firstDayOfMonth = DateTime(focused.year, focused.month, 1);
    DateTime lastDayOfMonth = DateTime(focused.year, focused.month + 1, 0);

    for (DateTime date = firstDayOfMonth;
        date.isBefore(lastDayOfMonth);
        date = date.add(Duration(days: 1))) {
      await _fetchEventsFromFirestore(date);
    }

    // Update the events data for the calendar
    setState(() {});
  }

  // Function to navigate to the EditEventPage with the selected event data
  Future<void> _editEvent(String event) async {
    final editedEvent = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => EditEventPage(event: event)),
    );

    if (editedEvent != null) {
      // Update the event data in the _eventsData map
      _selectedEvents.remove(event);
      _selectedEvents.add(editedEvent);
      _eventsData[_selected!] = _selectedEvents;

      // Update the events data for the calendar
      setState(() {});
    }
  }

  // Function to delete the event
  void _deleteEvent(String event) {
    // Remove the event from the _eventsData map
    _selectedEvents.remove(event);
    _eventsData[_selected!] = _selectedEvents;

    // Update the events data for the calendar
    setState(() {});
  }

  Color _textColor(DateTime day) {
    const _defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    } else if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return _defaultTextColor;
  }

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirestore(_focused);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ソフトテニス管理アプリ",
            style: TextStyle(
                color: Color.fromARGB(246, 241, 205, 172), fontSize: 19.0)),
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
            // TableCalendar
            TableCalendar(
                firstDay: DateTime.utc(2020, 4, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                locale: 'ja_JP',
                eventLoader: (day) {
                  // Ensure events for the currently focused month are displayed
                  if (_eventsData.containsKey(day)) {
                    return _eventsData[day] ?? [];
                  } else {
                    // If events for the day are not available, fetch and store them
                    _fetchEventsFromFirestore(day);
                    return [];
                  }
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
                    });
                    _fetchEventsFromFirestore(selected);
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
                )),
            Container(
              child: Text("イベント一覧"),
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
                      onTap: () {
                        // Open the EditEventPage when the list item is tapped
                        _editEvent(event);
                      },
                    ),
                  );
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
              child: Text('アプリ情報'),
            ),
            ListTile(
              title: Text('コート予約'),
              onTap: () {
                // 予約ページに遷移する処理
                _launchUrl();
              },
            ),
            ListTile(
              title: Text('ログアウト'),
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
}
