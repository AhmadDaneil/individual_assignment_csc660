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
      body: const Center(
        child: Text('Diary Entry'),
      ),
    );
  }
}