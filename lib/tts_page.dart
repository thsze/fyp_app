import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_tts/flutter_tts.dart';
import 'globals.dart';

class TTSpage extends StatefulWidget {
  const TTSpage({Key? key}) : super(key: key);

  @override
  State<TTSpage> createState() => _CustomSpeechState();
}

class _CustomSpeechState extends State<TTSpage> {
  String greetings = '';
  FlutterTts flutterTts = FlutterTts();

  final inputcontrol = TextEditingController();
  String langCode = "en-US";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: const Text('URL & TTS'),
          centerTitle: true,

          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: const Text('Settings'),
                              content: Center(
                                child: Column(
                                  children: <Widget>[
                                    const Text('Volume'),
                                    Slider(
                                      value: globals.volume,
                                      min: 0,
                                      max: 1,
                                      onChanged: (double value) {
                                        setState(() {
                                          globals.volume = value;
                                        });
                                      },
                                    ),
                                    const Text('Rate'),
                                    Slider(
                                      value: globals.rate,
                                      min: 0,
                                      max: 2,
                                      onChanged: (double value) {
                                        setState(() {
                                          globals.rate = value;
                                        });
                                      },
                                    ),
                                    const Text('Pitch'),
                                    Slider(
                                      value: globals.pitch,
                                      min: 0,
                                      max: 2,
                                      onChanged: (double value) {
                                        setState(() {
                                          globals.pitch = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                icon: const Icon(
                  Icons.settings,
                ))
          ]),

      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            height: 200,
            child: Container(

                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.cyan,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 0)
                    ]),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),

                child: Column(children: [
                  const Text(
                    'HTTP URL:',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    globals.url,
                    style: const TextStyle(fontSize: 20),
                  )
                ])),
          ),
          SizedBox(
            child: TextField(
              controller: inputcontrol,
              decoration: const InputDecoration(
                  icon: Icon(Icons.textsms_rounded), hintText: 'Enter a url'),

              onSubmitted: (String value) {
                setState(
                  () {
                    globals.url = value;
                  },
                );
              },
            ),
          ),
          SizedBox(
            child: TextField(
              controller: inputcontrol,
              decoration: const InputDecoration(
                  icon: Icon(Icons.textsms_rounded), hintText: 'Enter a TTS'),

              onSubmitted: (String value) {
                _speak(value);
              },
            ),
          ),
        ]),
      ),
    );
  }

  void _speak(String value) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setLanguage(language);
    await flutterTts.speak(value);
  }
}
