import 'dart:convert';
import 'package:http/http.dart';
import '../Utils/global.dart';
import 'news.dart';

class ApiService {
  final String apiUrl = "${baseURL}/news";

  getNews() async {
    Response res = await get(Uri.parse(apiUrl));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List newsList = body.map((dynamic item) => News.fromMap(item)).toList();
      return newsList;
    } else {
      throw "Failed to load News list";
    }
  }

  getNewsById(String id) async {
    final response = await get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return News.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load a case');
    }
  }

  createNews(News news, imagePath) async {
    var request = MultipartRequest('POST', Uri.parse('$baseURL/upload-news'));

    var pic = await MultipartFile.fromPath(
      'dataFile',
      imagePath,
      filename:
          'image_${news.title}.jpg',
    );

    request.fields['title'] = news.title;
    request.fields['content'] = news.content;
    request.fields['link'] = news.link;
    request.files.add(pic);

    var res = await request.send();
    return res;
  }

  updateNews(News news) async {
    Map data = news.toMap();

    final Response response = await put(
      Uri.parse('$apiUrl/${news.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Successfully updated ${news.id}");
    } else {
      throw Exception('Failed to update a case');
    }
  }

  deleteNews(String id) async {
    Response res = await delete(Uri.parse('$apiUrl/$id'));

    if (res.statusCode == 200) {
      print("Case deleted");
    } else {
      throw "Failed to delete a case.";
    }
  }
}
