import 'package:flutter/material.dart';
import 'package:wuxiaworld/html_scraper.dart';

import './chapter_page.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //HtmlScraper htmlScraper = HtmlScraper();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
//        appBar: AppBar(
//          title: Text("WuxiaWorld"),
//        ),
        body: ChapterPage(currentChapter: 0),
      ),
    );
  }
}
