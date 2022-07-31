import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_scan_app/view/translate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _image;
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  String englishText = '';

  Future<void> pickImageFromGallery() async {
    _image = await _picker.getImage(source: ImageSource.gallery);
    if (_image != null) {
      await processPickedFile();
    }
  }

  Future<void> processPickedFile() async {
    final inputImage = InputImage.fromFile(File(_image!.path));
    final recognisedText = await _textDetector.processImage(inputImage);
    for (TextBlock block in recognisedText.blocks) {
      final String text = block.text;
      englishText = englishText + ' $text';
    }
    englishText = englishText.replaceAll('\n', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 255, 203),
      body: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          children: [
            Container(
              width: 250,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 100, bottom: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                  ),
                ),
              ),
              child: const Text(
                'URL認識アプリ',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 200),
            Container(
              child: SizedBox(
                height: 100,
                width: 1000,
                child: ElevatedButton(
                    onPressed: () async {
                      await pickImageFromGallery();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TranslatePage(englishText, _image)));
                      englishText = '';
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 60, 107, 0), // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.collections,
                            color: Colors.white,
                            size: 50.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              '画像から検索',
                              style:
                                  TextStyle(fontSize: 24, letterSpacing: 1.0),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              child: SizedBox(
                height: 100,
                width: 1000,
                child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 60, 107, 0), // background
                      onPrimary: Colors.white, // foreground
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.history,
                            color: Colors.white,
                            size: 50.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              '履歴から検索',
                              style:
                                  TextStyle(fontSize: 24, letterSpacing: 1.0),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
