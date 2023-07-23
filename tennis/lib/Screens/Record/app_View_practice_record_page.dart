import 'package:flutter/material.dart';
import 'package:tennis/Screens/Record/View_tournament_record_page.dart';
import 'package:tennis/Screens/Record/view_practice_record_page.dart';

class AppRecordViewPage extends StatefulWidget {
  const AppRecordViewPage({Key? key}) : super(key: key);

  @override
  State<AppRecordViewPage> createState() => _AppRecordViewPage();
}

class _AppRecordViewPage extends State<AppRecordViewPage> {
  static final _screens = [
    PracticeViewPage(),
    TournamentViewPage(),
  ];
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
          unselectedItemColor: Color.fromARGB(246, 241, 205, 172),
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(246, 241, 205, 172)),
              label: '練習記録',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book,
                  color: Color.fromARGB(246, 241, 205, 172)),
              label: '大会記録',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(173, 49, 44, 44),
        ));
  }
}
