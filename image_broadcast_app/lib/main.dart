import 'package:flutter/material.dart';
import 'package:image_broadcast_app/screens/login_screen.dart';
import 'package:image_broadcast_app/screens/index_screen.dart';
import 'package:image_broadcast_app/screens/select_and_broadcast_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Broadcast App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/index': (context) => const IndexScreen(),
        '/select-broadcast': (context) => const SelectAndBroadcastScreen(),
      },
    );
  }
}
