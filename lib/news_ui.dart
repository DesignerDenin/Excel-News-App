import 'package:flutter/material.dart';
import 'Services/news.dart';
import 'Services/api_service.dart';
import 'Utils/global.dart';
import 'new_dialog.dart';
import 'news_tile.dart';
import 'update_dialog.dart';

class NewsUI extends StatefulWidget {
  const NewsUI({super.key});

  @override
  State<NewsUI> createState() => _NewsUIState();
}

class _NewsUIState extends State<NewsUI> {
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: white200, elevation: 0),
      backgroundColor: white200,
      body: RefreshIndicator(
        onRefresh: refresher,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FutureBuilder(
            future: api.getNews(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return NewsTile(
                          entry: snapshot.data[index],
                          updateNewsDialog: updateNewsDialog,
                        );
                      },
                    ),
                    const SizedBox(height: 140),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFAB(context),
      bottomNavigationBar: const BottomAppBar(
        height: 64,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        elevation: 12,
      ),
    );
  }

  customFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => newRoomDialog(context),
      backgroundColor: Colors.blue,
      child: const Icon(
        Icons.add,
        size: 32,
      ),
    );
  }

  newRoomDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewNewsForm();
      },
    ).then((value) => setState(() {}));
  }

  Future refresher() async {
    setState(() {
      api.getNews();
    });
    return Future<void>.delayed(const Duration(seconds: 1));
  }

  updateNewsDialog(BuildContext context, News entry) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateNewsForm(entry: entry);
      },
    ).then((value) => setState(() {}));
  }
}
