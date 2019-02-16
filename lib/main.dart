import 'package:flutter/material.dart';
import 'package:wuxiaworld/chapter_page.dart';
import './home_page.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //HtmlScraper htmlScraper = HtmlScraper();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          fontFamily: 'Merriweather'),
      routes: {
        '/': (BuildContext context) => HomePage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'novel') {
          String url = "";
          for (int i = 2; i < pathElements.length; i++) {
            url += pathElements[i];
            if (i != pathElements.length - 1) {
              url += "/";
            }
          }
          return MaterialPageRoute(
              builder: (BuildContext context) => ChapterPage(
                    currentChapter: 0,
                    baseURL: url,
                  ));
        }
        return null;
      },
    );
  }
}
