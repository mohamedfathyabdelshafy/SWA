import 'package:flutter/material.dart';
import 'package:swa/ui/screen/home/home_screen.dart';
import 'package:swa/ui/screen/registration/sign_in/ui_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginScreen.routeName: (_)=> LoginScreen(),
        HomeScreen.routeName :(_)=>HomeScreen()
      },
      initialRoute:LoginScreen.routeName,
    );
  }
}

