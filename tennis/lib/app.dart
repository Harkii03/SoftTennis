import 'package:flutter/material.dart';
import 'package:tennis/Screens/Home_page.dart';
import 'package:tennis/Screens/Record_page.dart';
import 'package:tennis/Screens/Video_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPage();
}

class _AppPage extends State<AppPage> {
  static const _screens = [HomePage(), RecordPage(), VideoPage()];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '記録'),
            BottomNavigationBarItem(icon: Icon(Icons.video_call), label: '動画'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
