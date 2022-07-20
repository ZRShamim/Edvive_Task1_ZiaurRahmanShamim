import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../utils/color.dart';
import '../utils/language.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  final GoogleTranslator translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

  bool speechEnabled = false;
  String speech = '';
  String translationResult = '';
  String? selectedLang = "Bengali";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      speech = result.recognizedWords;
    });
  }

  void translate(String text, String lang) async {
    var result = await translator.translate(speech, to: lang);
    setState(() {
      translationResult = result.toString();
    });
  }

  void speak(String text, String lang) async {
    await flutterTts.setLanguage(lang);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.25);
    await flutterTts.speak(text);
  }

  Widget textCard(String title, String mainText, String speakLang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        color: ColorsUsed.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 25,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          height: 150,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: ColorsUsed.textcolor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: mainText.isNotEmpty
                        ? () => speak(mainText, speakLang)
                        : null,
                    icon: Icon(
                      mainText.isNotEmpty
                          ? Icons.volume_up_rounded
                          : Icons.volume_off,
                      color: ColorsUsed.iconcolor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (speech.isEmpty)
                Text(
                  mainText.isNotEmpty
                      ? mainText
                      : speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              if (speech.isNotEmpty)
                Text(
                  mainText.isNotEmpty
                      ? mainText
                      : speechEnabled
                          ? 'press Translate to translate...'
                          : 'Speech not available',
                ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            textCard('Speech', speech, 'en'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: ColorsUsed.color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 25,
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Convert to",
                        style: TextStyle(
                          color: ColorsUsed.textcolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: ColorsUsed.color),
                        // color: Colors.white,
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            fillColor: ColorsUsed.color,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 5, color: ColorsUsed.color),
                            ),
                          ),
                          value: selectedLang,
                          items: TranslationLanguages.selectLanguages
                              .map((language) => DropdownMenuItem<String>(
                                    value: language,
                                    child: Text(
                                      language,
                                      style: const TextStyle(
                                          color: ColorsUsed.textcolor),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (language) =>
                              setState(() => selectedLang = language),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.deepPurple,
                          ),
                          iconSize: 42,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            speech.isNotEmpty
                                ? translate(
                                    speech,
                                    TranslationLanguages.getLanguageCode(
                                      selectedLang!,
                                    ),
                                  )
                                : null;
                          },
                          child: Text(
                            'Translate',
                            style: TextStyle(
                              color: speech.isNotEmpty
                                  ? ColorsUsed.textcolor
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            textCard(
              'Translation',
              translationResult,
              TranslationLanguages.getLanguageCode(
                selectedLang!,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
            backgroundColor: ColorsUsed.color,
            onPressed:
                speechToText.isNotListening ? startListening : stopListening,
            tooltip: 'Listen',
            child: Icon(
              speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              color: ColorsUsed.iconcolor,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
