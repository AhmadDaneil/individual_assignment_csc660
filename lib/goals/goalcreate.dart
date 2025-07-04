import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Goalcreate extends StatefulWidget {
    const Goalcreate({super.key});

  @override
  _AddGoalCreateScreenState createState() => _AddGoalCreateScreenState();
}

class _AddGoalCreateScreenState extends State<Goalcreate> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _saveGoal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('goals')
        .add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'deadline': _selectedDate?.toIso8601String(),
      'isCompleted': false,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal saved successfully')),
    );

    if (context.mounted) {
    Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Goal')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Title')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 10),
            TextButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text(_selectedDate == null ? 'Select Deadline' : _selectedDate.toString().split(' ')[0]),
              onPressed: _pickDate,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveGoal, child: Text('Save Goal')),
          ],
        ),
      ),
    );
  }
}



