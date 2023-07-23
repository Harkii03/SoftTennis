import 'package:flutter/material.dart';

import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';

//実機用(Youtube appに飛ぶ)
Future<void> _launchUrl(url) async {
  Uri _url = Uri.parse(url);
  if (!await canLaunchUrl(_url)) {
    throw Exception('Could not launch $_url');
  } else {
    await launch(_url.toString(), forceSafariVC: false);
  }
}

class MixDoublesPage extends StatefulWidget {
  const MixDoublesPage({Key? key}) : super(key: key);
  @override
  _MixDoublesPageState createState() => _MixDoublesPageState();
}

class _MixDoublesPageState extends State<MixDoublesPage> {
  // YoutubeAPIのキー
  static String key = "";
  YoutubeAPI youtube = YoutubeAPI(key, maxResults: 20, type: "video");
  List<YouTubeVideo> videoResult = [];

  Future<void> callAPI() async {
    String query = "ソフトテニス ミックスダブルス";
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
    return Scaffold(
        body: Container(
      color: const Color.fromARGB(196, 243, 228, 210),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "ミックスダブルスの動画",
              style: TextStyle(color: const Color.fromARGB(173, 49, 44, 44)),
            ),
          ),
          Expanded(
            child: ListView(
              children: videoResult.map<Widget>(listItem).toList(),
            ),
          ),
        ],
      ),
    ));
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
                      style: const TextStyle(fontSize: 11.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        video.channelTitle,
                        softWrap: true,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
