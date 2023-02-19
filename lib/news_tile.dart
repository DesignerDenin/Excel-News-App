import 'package:cached_network_image/cached_network_image.dart';
import 'package:excel_news/Services/api_service.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Services/news.dart';
import 'Utils/global.dart';
import 'package:flutter/material.dart';

typedef UpdateCallback = void Function(BuildContext context, News entry);

class NewsTile extends StatefulWidget {
  final News entry;
  final UpdateCallback updateNewsDialog;
  NewsTile({super.key, required this.entry, required this.updateNewsDialog});

  @override
  NewsTileState createState() => NewsTileState();
}

class NewsTileState extends State<NewsTile> {
  double diameter = 28;
  ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: white100,
        border: Border.all(color: white300),
        borderRadius: BorderRadius.circular(32),
      ),
      child: InkWell(
        onTap: () => widget.updateNewsDialog(context, widget.entry),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  newsPhoto(),
                  const SizedBox(height: 20),
                  Text(
                    widget.entry.title,
                    style: textDecoration,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.entry.content,
                    style: subTextDecoration,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: launchURL,
                  child: Text(
                    "Learn More",
                    style: linkTextDecoration,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        dateMsgGenerator(widget.entry.date),
                        style: dateTextDecoration,
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  var textDecoration = TextStyle(
    fontSize: 20,
    color: Colors.blueGrey.shade800,
    fontWeight: FontWeight.w800,
  );

  var subTextDecoration = TextStyle(
    fontSize: 16,
    color: Colors.blueGrey.shade800,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  var linkTextDecoration = const TextStyle(
    fontSize: 14,
    color: Colors.blue,
    fontWeight: FontWeight.w400,
  );

  var dateTextDecoration = TextStyle(
    fontSize: 14,
    color: Colors.blueGrey.shade400,
    fontWeight: FontWeight.w400,
  );

  newsPhoto() {
    return CachedNetworkImage(
      imageUrl: "$baseURL/uploads/${widget.entry.imageURL}",
      imageBuilder: (context, imageProvider) => Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  launchURL() async {
    var url = widget.entry.link;

    if(!url.startsWith("http")){
      url = "https://$url";
    }

    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  dateMsgGenerator(String postTime) {
    var currTime = DateTime.now().millisecondsSinceEpoch;
    var diff = currTime - int.parse(postTime);

    const sec = 1000;
    const min = sec * 60;
    const hour = min * 60;
    const day = hour * 24;
    const week = day * 7;

    var msg = "";

    if (diff < min) {
      msg = "${(diff / sec).round()} sec ago";
    } else if (diff < hour) {
      msg = "${(diff / min).round()} mins ago";
    } else if (diff < day) {
      msg = "${(diff / hour).round()} hrs ago";
    } else if (diff < week) {
      msg = "${(diff / day).round()} days ago";
    } else {
      msg = "${(diff / week).round()} weeks ago";
    }

    return msg;
  }
}
