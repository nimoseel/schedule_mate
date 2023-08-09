import 'package:flutter/material.dart';
import 'package:schedule_mate/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'IBMPlexSans',
      ),
      home: HomeScreen(),
    ),
  );
}
