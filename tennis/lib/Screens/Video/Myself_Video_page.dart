import 'package:flutter/material.dart';
import 'package:tennis/Screens/Video_page.dart';

class MyselfVideoPage extends StatefulWidget {
  @override
  State<MyselfVideoPage> createState() => _MyselfVideoPage();
}

class _MyselfVideoPage extends State<MyselfVideoPage> {
  //イベントのリストア

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("自分の動画",
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: const Color.fromARGB(173, 49, 44, 44),
      ),
      body: Column(
        children: [
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
                        border: Border.all(
                            color: Color.fromARGB(246, 241, 205, 172),
                            width: 2),
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
                        border: Border.all(
                          color: Color.fromARGB(246, 241, 205, 172),
                          width: 2,
                        ),
                        // 角丸
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 200,
                      height: 70,
                      child: OutlinedButton(
                          child: const Text('コートの予約'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () {}),
                    ),
                    //余白
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        // 枠線
                        border: Border.all(
                            color: Color.fromARGB(246, 241, 205, 172),
                            width: 2),
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
                    border: Border.all(
                        color: Color.fromARGB(246, 241, 205, 172), width: 2),
                    // 角丸
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('イベントを表示をさせる'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
