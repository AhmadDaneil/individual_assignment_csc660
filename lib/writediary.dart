import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Writediary extends StatefulWidget {
  const Writediary({super.key});

  @override
  State<Writediary> createState() => _WritediaryState();
}

class _WritediaryState extends State<Writediary> {

  final _textController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  String? _selectedEmoji;
  List<String> emojis = ['😊', '😢', '😡', '😴', '😐'];
  
  @override
  void dispose() {
    _textController.dispose(); // Avoid memory leaks
    super.dispose();
  }

  Future<void> _saveEntry() async {
    String entry = _textController.text.trim();
    if (entry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('diary').add({
        'entry': entry,
        'timestamp': DateTime.now(), // Always a valid DateTime
        'user_id': user?.uid,
        'emotion': _selectedEmoji ?? '📝',
      });
      _textController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Diary entry saved!')),
      );
      Navigator.pop(context); // to go back to HomePage
      } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving entry: $e')),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Diary'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How was your day?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: emojis.map((emoji) {
                return ChoiceChip(
                label: Text(emoji, style: const TextStyle(fontSize: 24)),
                selected: _selectedEmoji == emoji,
                onSelected: (_) {
                setState(() {
                  _selectedEmoji = emoji;
                });
                },
              );
               }).toList(),
            ),

            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'What happened today?',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: _saveEntry,
              minWidth: double.infinity,
              color: Colors.pink[100],
              textColor: Colors.lightBlue[800],
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


