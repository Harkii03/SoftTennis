import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';

// 予約ページに遷移する処理
Future<void> _launchUrl(url) async {
  Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // YoutubeAPIのキー
  static String key = "AIzaSyCLXOe1XbexwWjiF_tpy1H_HnkyejeKVPM";

  YoutubeAPI youtube = YoutubeAPI(key);
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
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // タイトル
        title: const Text('動画ページ',
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        // 背景色
        backgroundColor: Color.fromARGB(173, 49, 44, 44),
      ),
      body: Column(children: [
        Container(
          child: Text(
            "おすすめの動画",
            style: TextStyle(color: Color.fromARGB(132, 0, 0, 0)),
          ),
        ),

        // 動画一覧を表示するウィジェットを追加
        Expanded(
          child: ListView(
            children: videoResult.map<Widget>(listItem).toList(),
          ),
        ),
      ]),
    );
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

    ;
  }
}
