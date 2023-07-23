import 'package:flutter/material.dart';
import 'package:tennis/Screens/Home_page.dart';
import 'package:tennis/Screens/Record_page.dart';
import 'package:tennis/Screens/app_Video_page.dart';

import 'package:url_launcher/url_launcher.dart';

// 会津若松体育施設予約のURL
final Uri _url = Uri.parse('https://reserve.city.aizuwakamatsu.fukushima.jp/');

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPage();
}

class _AppPage extends State<AppPage> {
  static const _screens = [HomePage(), RecordPage(), null, AppVideoPage()];
  int _selectedIndex = 0;

  // 予約ページに遷移する処理
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        // If the "予約" item is pressed, launch the URL
        _launchUrl();
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color.fromARGB(246, 241, 205, 172),
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(246, 241, 205, 172)),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book,
                    color: Color.fromARGB(246, 241, 205, 172)),
                label: '記録'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book,
                    color: Color.fromARGB(246, 241, 205, 172)),
                label: '予約'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_call,
                    color: Color.fromARGB(246, 241, 205, 172)),
                label: '動画'),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(173, 49, 44, 44),
        ));
  }
}
