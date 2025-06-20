import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:individual_assignment/forgot.dart';
import 'package:individual_assignment/signup.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  bool isloading=false;

  signIn() async {
    setState(() {
      isloading=true;
    });
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );
  }on FirebaseAuthException catch(e){
    Get.snackbar("Error", e.code);
  }catch(e){
    Get.snackbar("Error", e.toString());
  }
  setState(() {
    isloading=false;
  });
}


  @override
  Widget build(BuildContext context) {
    return isloading?const Center(child: CircularProgressIndicator(),): Scaffold(
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
                    onPressed:(()=>signIn()),
                    color: Colors.pink[100],
                    textColor: Colors.lightBlue[800],
                    child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(onPressed: (()=>Get.to(const Signup())), child: const Text("Register")),
                  const SizedBox(height: 30,),
                  ElevatedButton(onPressed: (()=>Get.to(const Forgot())), child: const Text("Forgot Password")),
                ],
              ),
              ),
            ),
        ],
      ),
    );
  }
}