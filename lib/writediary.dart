import 'package:flutter/material.dart';

class Writediary extends StatefulWidget {
  const Writediary({super.key});

  @override
  State<Writediary> createState() => _WritediaryState();
}

class _WritediaryState extends State<Writediary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Diary'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical:30),
            child: Form(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText:'What happened today?'
                      
                    ),
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