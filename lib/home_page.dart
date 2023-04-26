import 'package:flutter/material.dart';
import 'package:glove_app/tts_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  List<Widget> pages = const [TTSpage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],

      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.waving_hand), label: "Debug"),
          //NavigationDestination(icon: Icon(Icons.history), label: "History")
        ],

        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
