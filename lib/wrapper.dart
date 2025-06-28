import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'login.dart';
import 'verifyemail.dart';
import 'loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'navigations/settings/settings_provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
@override
void initState() {
  super.initState();
  _loadUserSettings();
}

Future<void> _loadUserSettings() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        Provider.of<SettingsProvider>(context, listen: false).loadFromMap(data);
      }
    }
  }
}

@override
Widget build(BuildContext context) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Loading();
      } else if (snapshot.hasData) {
        if (snapshot.data!.emailVerified) {
          return const HomePage();
        } else {
          return const Verify();
        }
      } else {
        return const Login();
      }
    },
  );
}

}