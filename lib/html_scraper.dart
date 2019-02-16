import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class HtmlScraper {
  Future<List<String>> initiate(int chapterNumber, String baseURL) async {
    var client = Client();
    String url = "https://www." + baseURL + chapterNumber.toString();
    Response response = await client.get(url);

    if (response.statusCode != 200) {
      //return [response.body];
      return ["ERROR"];
    }

    // Use html parser
    var document = parse(response.body);
    List<Element> div = document.getElementsByClassName("fr-view");
    List<String> chapter = [];
    for (var i = 0; i < div[0].nodes.length; i++) {
      var node = div[0].nodes[i];
      if (node.toString() == '<html p>') {
        var text = div[0].nodes[i].text;
        chapter.add(text);
      }
    }
    return chapter;
  }
}
