import 'package:flutter/material.dart';
import 'package:tennis/Login/Login_page.dart';
import 'package:tennis/Screens/Event/Event_page.dart';

import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

// カレンダーに表示するデータを格納するMapを作成
Map<DateTime, List<String>> eventsMap = {};

// イベントのデータをFirestoreから取得
Future<Map<DateTime, List<String>>> getEventsFromFirestore() async {
  try {
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

    // Firestoreからイベントのデータを取得
    QuerySnapshot querySnapshot = await eventsCollection.get();

    // Firestoreから取得したデータをMapに変換
    querySnapshot.docs.forEach((document) {
      // startDateフィールドがnullでないことを確認してからキャストする
      if (document['startDate'] != null) {
        DateTime eventDate = (document['startDate'] as Timestamp).toDate();
        String eventName = document['eventName'];

        // イベントの日付をキーとして、イベント名をリストに追加
        if (eventsMap.containsKey(eventDate)) {
          eventsMap[eventDate]?.add(eventName);
        } else {
          eventsMap[eventDate] = [eventName];
        }
      }
    });

    return eventsMap;
  } catch (e) {
    print('Error fetching events from Firestore: $e');
    return {};
  }
}

DateTime _focused = DateTime.now();
DateTime? _selected;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  // カレンダーに表示するイベントデータを保持する変数
  Map<DateTime, List<String>> _eventsData = {};

  // カレンダーで選択された日付のイベントデータを保持する変数
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
          // カレンダーウィジェット
          FutureBuilder<Map<DateTime, List<String>>>(
            future: getEventsFromFirestore(), // Firestoreからイベントデータを取得
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // データ取得中の表示
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // データ取得エラー時の表示
                return Text('データの取得に失敗しました');
              } else {
                // データ取得成功時の表示
                _eventsData = snapshot.data ?? {};

                return TableCalendar(
                  firstDay: DateTime.utc(2020, 4, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  locale: 'ja_JP',
                  eventLoader: (date) {
                    return _eventsData[date] ?? [];
                  },
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
                );
              }
            },
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
    );
  }
}
