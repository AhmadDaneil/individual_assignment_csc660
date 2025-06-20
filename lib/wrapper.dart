import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'login.dart';
import 'verifyemail.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasData) {
            if (snapshot.data!.emailVerified){
              return const HomePage();
            }else{
              return const Verify();
            }
          }else{
            return const Login();
          }
        }
    );
  }
}