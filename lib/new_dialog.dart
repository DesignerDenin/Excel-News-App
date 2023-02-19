import 'dart:io';
import 'package:excel_news/Services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Services/news.dart';
import 'Utils/global.dart';

class NewNewsForm extends StatefulWidget {
  const NewNewsForm({super.key});

  @override
  NewNewsFormState createState() => NewNewsFormState();
}

class NewNewsFormState extends State<NewNewsForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  var file, imagePath;
  ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: white100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "New Announcement",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(white200),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(0)),
                    ),
                    onPressed: () {
                      pickImage();
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      child: file == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.blueGrey.shade300,
                                  size: 64,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Pick Image",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade400,
                                      fontSize: 16),
                                )
                              ],
                            )
                          : Container(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.blueGrey.shade900.withOpacity(0.5),
                                  BlendMode.srcATop,
                                ),
                                child: Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
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
                        if (file != null && _formKey.currentState!.validate()) {
                          onPressedCreate();
                        }
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Create News",
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

  Future pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        imagePath = file.path;
      });
    }
  }

  onPressedCreate() {
    News entry = News();
    entry.title = titleController.text;
    entry.content = contentController.text;
    entry.link = linkController.text;

    api.createNews(entry, imagePath);
    Navigator.pop(context);
  }
}
