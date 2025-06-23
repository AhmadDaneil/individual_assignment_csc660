import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:individual_assignment/verifyemail.dart';
import 'package:get/get.dart';

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
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
      
    );
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    Get.to(() => const Verify());
  } catch (e) {
    Get.snackbar('Error', e.toString());
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
                  Padding(padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter email' : null;
                    },
                  ),
                  ),
                  const SizedBox(height: 15),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter password' : null;
                    },
                  ),
                  ),
                  const SizedBox(height: 30),
                  Padding(padding: const EdgeInsets.symmetric(horizontal:35),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed:(()=>signUp()),
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