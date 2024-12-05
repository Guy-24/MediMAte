import 'package:flutter/material.dart';
import 'package:medimate/screen/form.dart';
import 'package:medimate/screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medimate',
      theme: ThemeData(
        //ธีม
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF191c23),
          onPrimary: Colors.white,
          secondary: Color(0xFF393939),
          onSecondary: Color(0xFFFFFFFF),
          surface: Color(0xFF121318),
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          inversePrimary: Colors.blueGrey,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121318),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF191c23)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.black),
        ),

        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Alarm",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        body: const Home(),
      ),
    );
  }
}
