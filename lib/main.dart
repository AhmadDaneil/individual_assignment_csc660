import 'package:flutter/material.dart';
import 'package:individual_assignment/homepage.dart';
import 'login.dart';
import 'writediary.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Login(),
      '/home': (context) => HomePage(),
      '/writediary': (context) => Writediary(),
    }
  ));
}
