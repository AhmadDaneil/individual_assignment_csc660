import 'package:flutter/material.dart';
import 'package:individual_assignment/homepage.dart';
import 'login.dart';
import 'writediary.dart';
import 'navigations/settings.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Login(),
      '/home': (context) => HomePage(),
      '/writediary': (context) => Writediary(),
      '/settings': (context) => Settings(),
    }
  ));
}
