import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'globals.dart' as globals;
import 'globals.dart';

TextToSpeech tts = TextToSpeech();

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[300],
        centerTitle: true,
        title: const Text('History'),
      ),

      body: checkifempty(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (globals.sentenceList.isNotEmpty) {
            globals.sentenceList.clear();
            setState(() {});
          }
        },
        child: const Icon(Icons.delete),
      ),
    );
  }

  Widget checkifempty() {
    return globals.sentenceList.isNotEmpty

        ? ListView.builder(
            itemCount: globals.sentenceList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(globals.sentenceList[index]),
                leading: const Icon(
                  Icons.play_arrow_rounded,
                ),

                onTap: () {
                  _speak(globals.sentenceList[index]);
                },
              );
            },
          )

        : const Scaffold();
  }

  void _speak (String value) async{
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.speak(value);
  }
}
