import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'chat_page.dart';
import 'globals.dart';
import 'history_page.dart';

class DevicePage extends StatefulWidget {
  final BluetoothDevice server;

  const DevicePage({Key? key, required this.server}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(server: widget.server),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.waving_hand), label: "Glove To Text"),
          NavigationDestination(icon: Icon(Icons.history), label: "History")
        ],
        onDestinationSelected: (int index) {
          if (index == 1) {
            setState(() {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      constraints: const BoxConstraints.expand(),
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.cyan[600],
                          centerTitle: true,
                          title: const Text('History'),
                        ),
                        body: checkifempty(),
                        floatingActionButton: FloatingActionButton(
                          backgroundColor: Colors.cyan[600],
                          onPressed: () {
                            if (sentenceList.isNotEmpty) {
                              sentenceList.clear();
                              setState(() {});
                            }
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          }
        },
      ),
    );
  }

  Widget checkifempty() {
    return sentenceList.isNotEmpty
        ? ListView.builder(
            itemCount: sentenceList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(sentenceList[index]),
                leading: const Icon(
                  Icons.play_arrow_rounded,
                ),
                onTap: () {
                  tts.setVolume(volume);
                  tts.setRate(rate);
                  tts.setPitch(pitch);
                  tts.setLanguage(language);
                  tts.speak(sentenceList[index]);
                },
              );
            },
          )
        : const Scaffold();
  }
}
