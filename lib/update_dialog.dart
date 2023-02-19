import 'package:cached_network_image/cached_network_image.dart';

import 'Services/api_service.dart';
import 'Services/news.dart';
import 'Utils/global.dart';
import 'package:flutter/material.dart';

class UpdateNewsForm extends StatefulWidget {
  UpdateNewsForm({super.key, required this.entry});
  final News entry;

  @override
  UpdateNewsFormState createState() => UpdateNewsFormState();
}

class UpdateNewsFormState extends State<UpdateNewsForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  var file, imagePath;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.entry.title;
    contentController.text = widget.entry.content;
    linkController.text = widget.entry.link;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Edit News",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => onPressedDelete(),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: Container(
                      height: 200, width: double.infinity, child: newsPhoto()),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: titleController,
                  style: formTextDecoration,
                  cursorColor: Colors.blue,
                  decoration: formFieldDecoration("Title"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "*This is a required Field";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contentController,
                  style: formTextDecoration,
                  cursorColor: Colors.blue,
                  maxLines: 3,
                  decoration: formFieldDecoration("Content"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "*This is a required Field";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: linkController,
                  style: formTextDecoration,
                  textAlignVertical: TextAlignVertical.top,
                  cursorColor: Colors.blue,
                  decoration: formFieldDecoration("Link"),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "*This is a required Field";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        onPressedUpdate();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Update News",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onPressedCancel() {
    Navigator.pop(context);
  }

  onPressedUpdate() async {
    widget.entry.title = titleController.text;
    widget.entry.content = contentController.text;
    widget.entry.link = linkController.text;

    api.updateNews(widget.entry);
    Navigator.pop(context);
  }

  onPressedDelete() async {
    api.deleteNews(widget.entry.id.toString());
    Navigator.pop(context);
  }

  var formTextDecoration = TextStyle(
    fontSize: 16,
    color: Colors.blueGrey.shade800,
    fontWeight: FontWeight.w500,
  );

  formFieldDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey.shade400),
          borderRadius: BorderRadius.circular(24.0)),
      labelStyle: TextStyle(
        color: Colors.blueGrey.shade400,
      ),
      focusColor: Colors.blue,
    );
  }

  newsPhoto() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.blueGrey.shade900.withOpacity(0.5),
        BlendMode.srcATop,
      ),
      child: CachedNetworkImage(
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
      ),
    );
  }
}
