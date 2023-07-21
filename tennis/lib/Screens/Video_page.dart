import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';

// 予約ページに遷移する処理
// Future<void> _launchUrl(url) async {
//   Uri _url = Uri.parse(url);
//   if (!await launchUrl(_url)) {
//     throw Exception('Could not launch $_url');
//   }
// }

//実機用(Youtube appに飛ぶ)
Future<void> _launchUrl(url) async {
  Uri _url = Uri.parse(url);
  if (!await canLaunchUrl(_url)) {
    throw Exception('Could not launch $_url');
  } else {
    await launch(_url.toString(), forceSafariVC: false);
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool isCollapsed = true;
  double screenWidth = 0, screenHeight = 0;
  final Duration duration = const Duration(milliseconds: 300);

  // YoutubeAPIのキー
  static String key = "";

  YoutubeAPI youtube = YoutubeAPI(key, maxResults: 20, type: "video");
  List<YouTubeVideo> videoResult = [];

  Future<void> callAPI() async {
    String query = "ソフトテニス";
    videoResult = await youtube.search(
      query,
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI();
    print('sucressed to get video data');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          // タイトル
          title: const Text('動画ページ',
              style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
          // 背景色
          backgroundColor: const Color.fromARGB(173, 49, 44, 44),
          leading: InkWell(
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            menu(),
            mainpage(context),
          ],
        ));
  }

  Widget mainpage(context) {
    return AnimatedPositioned(
        duration: duration,
        top: isCollapsed ? 0 : 0,
        bottom: isCollapsed ? 0 : 0,
        left: isCollapsed ? 0 : 0.4 * screenWidth,
        right: isCollapsed ? 0 : -0.4 * screenWidth,
        child: Material(
            animationDuration: duration,
            elevation: 8,
            color: const Color.fromARGB(196, 243, 228, 210),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    "おすすめの動画",
                    style: TextStyle(color: Color.fromARGB(132, 0, 0, 0)),
                  ),
                ),
                // 動画一覧を表示するウィジェット
                Expanded(
                  child: ListView(
                    children: videoResult.map<Widget>(listItem).toList(),
                  ),
                ),
              ],
            )));
  }

  Widget listItem(YouTubeVideo video) {
    return Card(
      child: InkWell(
          onTap: () {
            _launchUrl(video.url); // サムネイルをクリックしたらURLに遷移する
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 7.0),
            padding: EdgeInsets.all(1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Image.network(
                    video.thumbnail.small.url ?? '',
                    width: 140.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        video.title,
                        softWrap: true,
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          video.channelTitle,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget menu() {
    return Container(
      color: Color.fromARGB(173, 49, 44, 44),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // メニューの項目を GestureDetector でラップし、onTapで選択された項目を処理
            GestureDetector(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 1.0),
                  ),
                ),
                child: const Text(
                  'メニュー           ',
                  style: TextStyle(
                      color: Color.fromARGB(246, 241, 205, 172), fontSize: 22),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 1.0,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Singlesがタップされたときの処理
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                child: const Text(
                  'Singles                ',
                  style: TextStyle(
                      color: Color.fromARGB(246, 241, 205, 172), fontSize: 20),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Doublesがタップされたときの処理
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                child: const Text(
                  'Doubles               ',
                  style: TextStyle(
                      color: Color.fromARGB(246, 241, 205, 172), fontSize: 20),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Mixd Doublesがタップされたときの処理
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 9),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                child: const Text(
                  'Mix Doubles      ',
                  style: TextStyle(
                      color: Color.fromARGB(246, 241, 205, 172), fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
