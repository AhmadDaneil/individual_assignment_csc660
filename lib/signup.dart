import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:individual_assignment/verifyemail.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController name=TextEditingController();
  
  
  signUp() async {
  try {
    // Create user with Firebase Auth
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    User? user = userCredential.user;

    if (user != null) {
      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name.text.trim(),
        'email': user.email,
        'uid': user.uid,
      });

      // Optional: update Firebase display name
      await user.updateDisplayName(name.text.trim());

      // Send email verification
      await user.sendEmailVerification();

      // Navigate to verification page
      Get.to(() => const Verify());
    }
  } catch (e) {
    Get.snackbar('Signup Error', e.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.book,
            size: 100,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Please enter name' : null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Please enter email' : null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Please enter password' : null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(padding: const EdgeInsets.symmetric(horizontal:35),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed:() => signUp(),
                    color: Colors.pink[100],
                    textColor: Colors.lightBlue[800],
                    child: const Text('Sign Up'),
                    ),
                  )
                ],
              ),
              ),
            ),
        ],
      ),
    );
  }
}