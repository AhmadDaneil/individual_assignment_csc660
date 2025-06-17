import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                    onPressed:() async{
                    await Navigator.pushNamed(context, '/home');
                    },
                    color: Colors.pink[100],
                    textColor: Colors.lightBlue[800],
                    child: const Text('Login'),
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