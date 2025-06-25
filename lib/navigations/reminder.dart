import 'package:flutter/material.dart';

class Reminder extends StatefulWidget {
  const Reminder({super.key});

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
      
    );
  }
}