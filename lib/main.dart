import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'homepage.dart';
import 'writediary.dart';
import 'navigations/settings/settings.dart';
import 'navigations/about.dart';
import 'wrapper.dart';
import 'goals/goalcreate.dart';
import 'goals/goalview.dart';
import 'package:individual_assignment/navigations/settings/settings_provider.dart';
import 'login.dart';
import 'signup.dart';
import 'forgot.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return GetMaterialApp(
  debugShowCheckedModeBanner: false,
  themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
  theme: ThemeData(
  scaffoldBackgroundColor: settings.backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: settings.appBarColor,
    foregroundColor: Colors.white,
  ),
  textTheme: Theme.of(context).textTheme.apply(
    fontSizeFactor: settings.fontSize / 16.0,
  ),
),
darkTheme: ThemeData.dark().copyWith(
  scaffoldBackgroundColor: settings.backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: settings.appBarColor,
    foregroundColor: settings.isDarkMode ? Colors.white : Colors.black,
  ),
  textTheme: Theme.of(context).textTheme.apply(
    fontSizeFactor: settings.fontSize / 16.0,
  ),
),
      initialRoute: '/wrapper',
      routes: {
      '/home': (context) => const HomePage(),
      '/login': (context) => const Login(),
      '/forgot': (context) => const Forgot(),
      '/writediary': (context) => const Writediary(),
      '/settings': (context) => const Settings(),
      '/wrapper':(context) => const Wrapper(),
      '/about': (context) => const About(),
      '/goalcreate': (context) => const Goalcreate(),
      '/goalview': (context) => Goalsview(),
      '/signup': (context) => const Signup(),
      },
        );
    },
  );
  }
}
