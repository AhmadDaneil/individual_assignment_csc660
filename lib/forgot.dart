import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  TextEditingController email=TextEditingController();
  
  reset() async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);(
      email: email.text.trim(),
      
    );
  } catch (e) {
    if(!mounted)return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $e')),
    );
    
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password"),
      ),
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
                 
                  const SizedBox(height: 30),
                  Padding(padding: const EdgeInsets.symmetric(horizontal:35),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed:(()=>reset()),
                    color: Colors.pink[100],
                    textColor: Colors.lightBlue[800],
                    child: const Text('Send link'),
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