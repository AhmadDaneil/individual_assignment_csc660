import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'homepage.dart';
import 'writediary.dart';
import 'navigations/settings.dart';
import 'wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Wrapper(),
    routes: {
      '/home': (context) => HomePage(),
      '/writediary': (context) => Writediary(),
      '/settings': (context) => Settings(),
      '/wrapper':(context) => Wrapper(),
    }
  ));
}
