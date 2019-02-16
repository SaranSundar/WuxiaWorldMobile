import 'dart:convert';
import './chapter_page.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> novels;

  @override
  void initState() {
    super.initState();
    loadNovels();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = buildBody(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("WuxiaWorld"),
      ),
      body: body,
    );
  }

  Widget buildBody(BuildContext context) {
    if (novels == null) {
      return Center(child: CircularProgressIndicator());
    } else if (novels.length == 0) {
      return Center(child: Text("No Novels Found"));
    }
    return GridView.count(
      childAspectRatio: 0.6,
      crossAxisCount: 3,
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      children: List.generate(novels["novels"]["wuxiaworld"].length, (index) {
        var wuxia_novels = novels["novels"]["wuxiaworld"];
        return Container(
          margin: EdgeInsets.all(10.0),
//          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      '/novel/' +
                          wuxia_novels["book" + (index + 1).toString()]
                              ["baseURL"]);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  margin: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          wuxia_novels["book" + (index + 1).toString()]
                              ["imgSrc"]),
                    ),
                  ),
                ),
              ),
              Text(
                styleTitle(
                    wuxia_novels["book" + (index + 1).toString()]["title"]),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  String styleTitle(String title) {
    title = title.replaceAll("-", " ");
    List<String> words = title.split(" ");
    String newTitle = "";
    for (int i = 0; i < words.length; i++) {
      String s = words[i];
      newTitle += s.substring(0, 1).toUpperCase() + s.substring(1) + " ";
    }
    return newTitle.trim();
  }

  loadNovels() async {
    String novelsJSONString =
        await rootBundle.loadString('assets/json/novels.json');
    setState(() {
      novels = jsonDecode(novelsJSONString);
//      print(novelsJSONString);
//      print("###############");
//      print(novels["novels"]["wuxiaworld"]["book1"]);
    });
  }
}
