import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule_mate/database/drift_database.dart';
import 'package:schedule_mate/screen/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'IBMPlexSans',
      ),
      home: const HomeScreen(),
    ),
  );
}
