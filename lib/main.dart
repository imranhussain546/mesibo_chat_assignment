import 'package:flutter/material.dart';
import 'package:mesibo_chat_assignment/auth/view/login.dart';
import 'package:mesibo_flutter_sdk/mesibo.dart';

class DemoUser {
  String token = "";
  String address = "";

  DemoUser(String t, String a) {
    token = t;
    address = a;
  }
}
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const Login(),
    );
  }
}



