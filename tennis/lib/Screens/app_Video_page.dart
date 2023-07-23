import 'package:flutter/material.dart';
import 'Video/Singles_page.dart';
import 'Video/Doubles_page.dart';
import 'Video/MixDoubles_page.dart';
import 'Video/Video_page.dart';

class AppVideoPage extends StatefulWidget {
  const AppVideoPage({Key? key}) : super(key: key);
  @override
  _AppVideoPageState createState() => _AppVideoPageState();
}

class _AppVideoPageState extends State<AppVideoPage> {
  static const _screens = [
    VideoPage(),
    SinglesPage(),
    DoublesPage(),
    MixDoublesPage()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('動画ページ',
              style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
          backgroundColor: const Color.fromARGB(173, 49, 44, 44),
        ),
        body: _screens[_selectedIndex],
        drawer: Drawer(
            child: ListView(children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: const Color.fromARGB(173, 49, 44, 44)),
            child: const Text('Application inforrmation'),
          ),
          ListTile(
              title: const Text('あなたのおすすめ'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              }),
          ListTile(
              title: const Text('シングルス'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              }),
          ListTile(
              title: const Text('ダブルス'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              }),
          ListTile(
              title: const Text('ミックスダブルス'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              }),
        ])));
  }
}
