import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class TranslatePage extends StatefulWidget {
  final String englishText;
  var _image;
  TranslatePage(this.englishText, this._image, {Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String japaneseText = '';
  final LanguageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();
  final OnDeviceTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: TranslateLanguage.ENGLISH,
      targetLanguage: TranslateLanguage.JAPANESE);

  Future<void> downlodeModel() async {
    await LanguageModelManager.downloadModel('en');
    await LanguageModelManager.downloadModel('ja');

    // await translateText();
  }

  Future<void> translateText() async {
    var result = await OnDeviceTranslator.translateText(widget.englishText);
    setState(() {
      japaneseText = result;
    });
  }

  @override
  void initState() {
    super.initState();
    downlodeModel();
  }

  @override
  void dispose() {
    super.dispose();
    OnDeviceTranslator.close();
  }

  @override
  Widget build(BuildContext context) {
    final urlRegExp = RegExp(r'http[a-zA-Z0-9\-%_/=&?.\s\/\:]+');
    var urlMatches = urlRegExp.allMatches(widget.englishText);
    List<String> urls = urlMatches
        .map((urlMatch) =>
            widget.englishText.substring(urlMatch.start, urlMatch.end))
        .toList();
    urls.forEach((value) {});
    var url_2 = '';
    var url_3 = urls.elementAt(0);
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('URL'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(child: Image.file(File(widget._image!.path))),
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              widget.englishText,
              style: TextStyle(fontSize: 16, height: 2),
            ),
          ),
        )),
        Expanded(
          child: TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              controller: TextEditingController(text: '$url_3'),
              onChanged: (value) {
                url_2= value;
              },
            ),
        ),
        ElevatedButton(
          onPressed: () async {
            final url = Uri.parse(
              '$url_2',
            );
            if (await canLaunchUrl(url)) {
              launchUrl(url);
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          },
          child: const Text('Web Link'),
        )
      ]),
    );
  }
}
