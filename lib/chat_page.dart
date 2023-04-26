import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:glove_app/globals.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:text_to_speech/text_to_speech.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({super.key, required this.server});

  @override
  _ChatPage createState() => _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  BluetoothConnection? connection;
  bool isButtonPressed = false;
  Timer timer = Timer(Duration.zero, () {});
  List<_Message> messages = List<_Message>.empty(growable: true);
  String finalResult = '';
  String receivedMessage = '';
  String totalMessage = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();


  bool isConnecting = true;

  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  TextToSpeech tts = TextToSpeech();
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
        } else {
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
    });
  }



  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
        appBar: AppBar(
            title: (isConnecting
                ? Text('Connecting chat to $serverName...')
                : isConnected
                    ? Text('Connected with $serverName')
                    : Text('Disconnected with $serverName')),
            backgroundColor: Colors.cyan[600],
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
                                        value: volume,
                                        min: 0,
                                        max: 1,
                                        onChanged: (double value) {
                                          setState(() {
                                            volume = value;
                                          });
                                        },
                                      ),
                                      const Text('Rate'),
                                      Slider(
                                        value: rate,
                                        min: 0,
                                        max: 1,
                                        onChanged: (double value) {
                                          setState(() {
                                            rate = value;
                                          });
                                        },
                                      ),
                                      const Text('Pitch'),
                                      Slider(
                                        value: pitch,
                                        min: 0,
                                        max: 2,
                                        onChanged: (double value) {
                                          setState(() {
                                            pitch = value;
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                          'Message:',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          finalResult,
                          style: const TextStyle(fontSize: 15),
                        )
                      ])),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isConnected) {
                      setState(() {
                        isButtonPressed = !isButtonPressed;
                        if (isButtonPressed) {
                          _sendData("start");
                          setState(() {
                            finalResult = "*Recording...*";
                          });
                        } else {
                          _stopSendingData();
                          _sendData("stop");
                        }
                      });
                    } else {
                      null;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor:
                          isButtonPressed ? Colors.red : Colors.cyan[600]),
                  child: Text(
                    isButtonPressed ? "IN PROGRESS" : "START",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0),
                        child: TextField(
                          style: const TextStyle(fontSize: 15.0),
                          controller: textEditingController,
                          decoration: InputDecoration.collapsed(
                            hintText: isConnecting
                                ? 'Wait until connected...'
                                : isConnected
                                    ? 'Type your message...'
                                    : 'Device got disconnected',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          //enabled: isConnected,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            _speak(textEditingController.text);
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _sendData(String data) async {
    Uint8List bytes = Uint8List.fromList(utf8.encode("$data\r\n"));
    connection?.output.add(bytes);
    await connection?.output.allSent;
  }

  void _stopSendingData() {
    timer.cancel();
  }

  Future<void> _onDataReceived(Uint8List data) async {
    setState(() {
      receivedMessage = const Utf8Decoder().convert(data);
      totalMessage = totalMessage + receivedMessage;
      finalResult = "*Classifying...*";
    });
    if (totalMessage[totalMessage.length - 1] == ']') {
      sendHTTP(totalMessage);
    }
  }

  Future<void> sendHTTP(String message) async {
    Map<String, dynamic> dataMap = {
      'data': message,
    };
    final response = await http.post(Uri.http(url, '/data'), body: dataMap);
    totalMessage = '';
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      finalResult = decoded['test'];
      _speak(finalResult);
      isButtonPressed = false;
      sentenceList.add(finalResult);
    });
  }

  void _speak (String value) async{
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setLanguage(language);
    await flutterTts.speak(value);
  }
}
