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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(alignment: AlignmentDirectional.center, children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 255, 132),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
              const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'URLスキャン',
                    style: TextStyle(
                        fontSize: 23,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w100,
                        letterSpacing: 3.0),
                  ))
            ]),
            Container(
              padding: const EdgeInsets.only(top: 50),
              margin: const EdgeInsets.all(25),
              child: SizedBox(
                height: 110,
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
                      primary: Colors.red[100], // background
                      onPrimary: Colors.white, // foreground
                    ),
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
                            '画像選択',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Text('MLkit'),
    //         const SizedBox(height: 100),
    //         SizedBox(
    //           height: 50,
    //           width: 200,
    //           child: ElevatedButton(
    //               onPressed: () async {
    //                 await pickImageFromGallery();
    //                 await Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) => TranslatePage(englishText)));
    //                 englishText = '';
    //               },
    //               child: const Text('画像選択')),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
