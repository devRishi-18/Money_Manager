import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:newproject2/pages/add_details.dart';
import 'package:newproject2/pages/homepage.dart';
import 'package:newproject2/pages/splash.dart';
import 'package:newproject2/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: const Splash(),
    );
  }
}

