import 'dart:async';

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
  bool releaseScreen = false;
  double pullDistance = 100.0;
  final String top = "Top";
  final String bottom = "Bottom";
  bool showLoadingScreen = true;
  bool changeScroll = false;
  String tempDirection = "Bottom";

  _ChapterPageState(this.currentChapter);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    loadChapter("");
  }

  void showHideOptionsMenu() {
    setState(() {
      containerHeight = containerHeight == 0 ? 75 : 0.0;
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  void loadChapter(String direction) {
    setState(() {
      showLoadingScreen = true;
      //chapter = []; // Reset chapter to show loading animation
    });
    getChapter().then((result) {
      setState(() {
        print("setting state 1");
        chapter = result;
        showLoadingScreen = false;
        changeScroll = true;
        tempDirection = direction;
      });
//      setState(() {
//        print("setting state 2");
//        if (changeScroll) {
//          changeScroll = false;
//          if (tempDirection == top) {
//            scrollController.jumpTo(scrollController.position.maxScrollExtent);
//          } else if (tempDirection == bottom) {
//            scrollController.jumpTo(scrollController.position.minScrollExtent);
//          }
//        }
//      });
    });
  }

  void scrollPage() {
    //Bottom Of Page
    if (scrollController.offset >=
        scrollController.position.maxScrollExtent + pullDistance) {
      currentChapter += 1;
      loadChapter(bottom);
    }
    // Top of Page
    else if (scrollController.offset <=
        scrollController.position.minScrollExtent - pullDistance) {
      currentChapter -= 1;
      loadChapter(top);
    }
  }

  Future<List<String>> getChapter() async {
    HtmlScraper htmlScraper = HtmlScraper();
    return await htmlScraper.initiate(currentChapter);
  }

  @override
  Widget build(BuildContext context) {
    print("building widget");
    scrollListView();
    MediaQueryData queryData = MediaQuery.of(context);
    var chapterText = "";
    var titleText = "";
    if (chapter.length < 1) {
    } else if (chapter.length == 1 && chapter[0] == "ERROR") {
      chapterText = "Chapter doesn't exist or try reloading the page.";
      titleText = "ERROR";
    } else {
      chapterText =
          chapter.skip(1).toList().reduce((curr, next) => curr + next + "\n\n");
      titleText = chapter[0] + "\n";
    }
    if (chapter.length > 0) {
      chapterLoaded = true;
    }
    var stack = Stack(
      // Stacks List View with Options Menu on Top
      children: <Widget>[
        Visibility(
          maintainState: true,
          visible: !showLoadingScreen,
          child: Listener(
              onPointerUp: (pointer) {
                releaseScreen = true;
                scrollPage();
              },
              onPointerDown: (pointer) {
                releaseScreen = false;
              },
              child: getChapterWidget(
                  titleText, chapterText, queryData.size.height)),
        ),
        Visibility(visible: !showLoadingScreen, child: getOptionsMenu()),
        Visibility(
          visible: showLoadingScreen,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
    return stack;
  }

  void scrollListView() {
    if (changeScroll) {
      changeScroll = false;
      if (tempDirection == top) {
        Timer(
            Duration(milliseconds: 0),
            () => scrollController
                .jumpTo(scrollController.position.maxScrollExtent));

        //scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } else if (tempDirection == bottom) {
        Timer(
            Duration(milliseconds: 0),
            () => scrollController
                .jumpTo(scrollController.position.minScrollExtent));

        //scrollController.jumpTo(scrollController.position.minScrollExtent);
      }
    }
  }

  Widget getChapterWidget(
      String titleText, String chapterText, double screenHeight) {
    var l = ListView(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        GestureDetector(
          onTap: showHideOptionsMenu,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(children: [
                Text(
                  titleText,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
                Text(
                  chapterText,
                  style: TextStyle(fontSize: 20.0),
                ),
              ]),
            ),
          ),
        )
      ],
    );
    return l;
  }

  Widget getOptionsMenu() {
    return AnimatedContainer(
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
              onPressed: () {
                loadChapter(top);
              },
              color: Colors.blue,
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      duration: Duration(milliseconds: 130),
    );
  }
}
