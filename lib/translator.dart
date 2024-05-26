import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'them.dart';

class TranslatorPage extends StatefulWidget {
  final String? detectedText;

  TranslatorPage({this.detectedText});

  @override
  _TranslatorPageState createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  String fromLanguage = 'English';
  String toLanguage = 'Select language';
  TextEditingController textController = TextEditingController();
  String translatedText = '';
  final translator = GoogleTranslator(); // Create an instance of GoogleTranslator
  late stt.SpeechToText _speech; // Instance of SpeechToText
  bool _isListening = false; // Flag to check if the speech recognizer is listening
  String _spokenText = ''; // Text obtained from speech recognition
  final FlutterTts flutterTts = FlutterTts(); // Instance of FlutterTts

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    if (widget.detectedText != null) {
      textController.text = widget.detectedText!;
    }
  }

  void swapLanguages() {
    setState(() {
      if (toLanguage != 'Select language') {
        String temp = fromLanguage;
        fromLanguage = toLanguage;
        toLanguage = temp;
        textController.clear();
        translatedText = '';
      }
    });
  }

  Future<void> translateText() async {
    String fromLangCode = _getLanguageCode(fromLanguage);
    String toLangCode = _getLanguageCode(toLanguage);

    if (toLangCode == 'select') {
      setState(() {
        translatedText = 'Please select a target language';
      });
      return;
    }

    try {
      var translation = await translator.translate(
        textController.text,
        from: fromLangCode,
        to: toLangCode,
      );
      setState(() {
        translatedText = translation.text;
      });
    } catch (e) {
      setState(() {
        translatedText = 'Translation failed';
      });
      print('Translation failed: $e');
    }
  }

  Future<void> speakText(String text) async {
    String lang = _getLanguageCode(toLanguage);
    String voice = Provider.of<ThemeNotifier>(context, listen: false).voice;
    await flutterTts.setLanguage(lang);
    if (voice == 'Male') {
      await flutterTts.setPitch(0.5);
    } else {
      await flutterTts.setPitch(1.8);
    }
    await flutterTts.speak(text);
  }

  void reset() {
    setState(() {
      textController.clear();
      translatedText = '';
    });
  }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'French':
        return 'fr';
      case 'Arabic':
        return 'ar';
      default:
        return 'select';
    }
  }

  List<String> getAvailableLanguages() {
    return ['English', 'French', 'Arabic'];
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _spokenText = val.recognizedWords;
            textController.text = _spokenText;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    int textSize = Provider.of<ThemeNotifier>(context).textSize;

    return Scaffold(
      appBar: AppBar(
        title: Text('Astro AI Translator'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Container(
        color: isDarkMode ? Colors.black45 : Color(0xFFE5E0E0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: fromLanguage,
                  items: getAvailableLanguages().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != toLanguage) {
                      setState(() {
                        fromLanguage = newValue;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, color: isDarkMode ? Colors.white : Colors.black),
                  onPressed: swapLanguages,
                ),
                DropdownButton<String>(
                  value: toLanguage,
                  items: ['Select language', ...getAvailableLanguages().where((lang) => lang != fromLanguage)].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      toLanguage = newValue!;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Press the button and talk',
                      hintStyle: TextStyle(color: isDarkMode ? Colors.black54 : Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.mic, color: _isListening ? Colors.red : Colors.blue),
                        onPressed: _listen,
                      ),
                    ),
                    style: TextStyle(fontSize: textSize.toDouble(), color: isDarkMode ? Colors.black54 : Colors.black),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await translateText();
                      await speakText(translatedText);
                    },
                    child: Text('Translate & Speak'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: translatedText),
                    decoration: InputDecoration(
                      hintText: 'Translation',
                      hintStyle: TextStyle(color: isDarkMode ? Colors.black54 : Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.volume_up, color: isDarkMode ? Colors.black54 : Colors.black),
                        onPressed: () async {
                          await speakText(translatedText);
                        },
                      ),
                    ),
                    style: TextStyle(fontSize: textSize.toDouble(), color: isDarkMode ? Colors.black54 : Colors.black),
                    readOnly: true,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh, color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: reset,
                  ),
                  Text(
                    'Refresh',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt, color: isDarkMode ? Colors.white : Colors.black),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz, color: isDarkMode ? Colors.white : Colors.black),
            label: 'More',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/camera');
          else if (index == 1) Navigator.pushNamed(context, '/more');
        },
      ),
    );
  }
}
