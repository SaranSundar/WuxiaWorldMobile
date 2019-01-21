import 'package:flutter/material.dart';

import './html_scraper.dart';

class ChapterPage extends StatefulWidget {
  final int currentChapter;

  ChapterPage({this.currentChapter});

  @override
  State<StatefulWidget> createState() {
    return _ChapterPageState(currentChapter);
  }
}

class _ChapterPageState extends State<ChapterPage> {
  List<String> chapter = [];
  double opacityLevel = 0.0;
  double containerHeight = 0.0;
  int currentChapter;
  ScrollController scrollController;
  bool chapterLoaded = false;
  bool lock = false;

  _ChapterPageState(this.currentChapter);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    loadChapter();
  }

  void scrollListener() {
    //print(scrollController.offset);
//    if (lock == false) {
//      print("Locking");
//      if (scrollController.offset >=
//              scrollController.position.maxScrollExtent &&
//          !scrollController.position.outOfRange) {
//        lock = true;
//        //Bottom
//        currentChapter += 1;
//        //loadChapter();
//      }
//      if (scrollController.offset <=
//              scrollController.position.minScrollExtent &&
//          !scrollController.position.outOfRange) {
//        //Top
//        lock = true;
//        currentChapter -= 1;
//        //loadChapter();
//      }
//    }
  }

  void _changeOpacity() {
    setState(() {
      containerHeight = containerHeight == 0 ? 75 : 0.0;
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  void loadChapter() {
    //print("LOADING NEW CHAPTER");
    getChapter().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        //print("DONE LOADING CHAPTER");
        chapter = result;
        if (chapterLoaded) {
          scrollController.jumpTo(10);
          print("Unlocking");
          lock = false;
        }
      });
    });
  }

  Future<List<String>> getChapter() async {
    HtmlScraper htmlScraper = HtmlScraper();
    //print("Current Chapter: " + currentChapter.toString());
    return await htmlScraper.initiate(currentChapter);
  }

  @override
  Widget build(BuildContext context) {
    var chapterText = "";
    var titleText = "";
    if (chapter.length < 1) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (chapter.length == 1 && chapter[0] == "ERROR") {
      chapterText =
          "Chapter doesn't exist or try reloading the page\n\n\n\n\n\n\n\n\n\n\n\n";
      titleText = "ERROR";
    } else {
      chapterText =
          chapter.skip(1).toList().reduce((curr, next) => curr + next + "\n\n");
      titleText = chapter[0] + "\n";
    }
    if (chapter.length > 0) {
      chapterLoaded = true;
    }
    return Stack(
      children: <Widget>[
        ListView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            GestureDetector(
              onTap: _changeOpacity,
              onPanUpdate: (details) {
                print(details.toString());
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(children: [
                  Text(
                    titleText,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                  ),
                  Text(
                    chapterText,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ]),
              ),
            ),
          ],
        ),
        AnimatedContainer(
          width: double.infinity,
          height: containerHeight,
          color: Colors.amber,
          child: Opacity(
            opacity: opacityLevel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.fromLTRB(0, 18, 15, 0),
                  iconSize: 35,
                  onPressed: loadChapter,
                  color: Colors.blue,
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          duration: Duration(milliseconds: 130),
        ),
      ],
    );
  }
}
