import 'package:glove_app/bluetooth_page.dart';
import 'package:flutter/material.dart';
import 'package:glove_app/home_page.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  [
    Permission.location,
    Permission.storage,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request().then((status) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primaryColor: Colors.blue),

      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[600],
          centerTitle: true,
          title: const Text('Gesture to Speech Gloves'),
        ),

        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Center(
                    // small button
                    child: ElevatedButton.icon(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 50),
                        ),

                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return BluetoothPage();
                              },
                            ),
                          );
                        },
                        label: const Text('Connect to Glove'),
                        icon: const Icon(Icons.volume_up_rounded)),
                  ),
                  Center(
                    // small button
                    child: ElevatedButton.icon(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 50),
                        ),

                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const HomePage();
                              },
                            ),
                          );
                        },
                        label: const Text('Debug'),
                        icon: const Icon(Icons.bug_report)),
                  )
                ])));
  }
}
