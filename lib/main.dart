import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:individual_assignment/navigations/reminder.dart';
import 'homepage.dart';
import 'writediary.dart';
import 'package:get/get.dart';
import 'navigations/settings/settings.dart';
import 'wrapper.dart';
import 'navigations/about.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Wrapper(),
    routes: {
      '/home': (context) => const HomePage(),
      '/writediary': (context) => const Writediary(),
      '/settings': (context) => Settings(),
      '/wrapper':(context) => const Wrapper(),
      '/about': (context) => const About(),
      '/reminder':(context) => const Reminder(),
    }
  ));
}
