import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_text_detect_area/flutter_text_detect_area.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;
import 'translator.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String detectedText = '';
  String detectedLanguage = '';

  @override
  void initState() {
    super.initState();
    langdetect.initLangDetect();
  }

  void detectLanguage(String text) async {
    final language = langdetect.detect(text);
    setState(() {
      detectedLanguage = _getFullLanguageName(language);
    });
  }

  String _getFullLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'ar':
        return 'Arabic';
      default:
        return 'Unknown';
    }
  }

  void _processImage(String? imagePath) {
    if (imagePath != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SelectImageAreaTextDetect(
          detectOnce: true,
          enableImageInteractions: true,
          imagePath: imagePath,
          onDetectText: (v) {
            setState(() {
              detectedText = '';
              if (v is String) {
                detectedText = v;
              }
              if (v is List) {
                int counter = 0;
                v.forEach((element) {
                  detectedText += "$counter. \t\t $element \n\n";
                  counter++;
                });
              }
              detectLanguage(detectedText);
            });
          },
          onDetectError: (error) {
            print(error);
            if (error is PlatformException &&
                (error.message?.contains("InputImage width and height should be at least 32!") ?? false)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Selected area should be able to crop image with at least 32 width and height."),
              ));
            }
          },
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Text Detection'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: isDarkMode ? Colors.black45 : Color(0xFFE5E0E0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                  _processImage(pickedFile?.path);
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Capture and Detect Text'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  _processImage(pickedFile?.path);
                },
                icon: Icon(Icons.photo_library),
                label: Text('Select Image from Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Detected Text:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    detectedText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Detected Language: $detectedLanguage',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: detectedText.isNotEmpty
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TranslatorPage(detectedText: detectedText)),
                  );
                }
                    : null,
                icon: Icon(Icons.translate),
                label: Text('Translate Text'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
