import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:individual_assignment/navigations/settings/settings_provider.dart';

class Writediary extends StatefulWidget {
  const Writediary({super.key});

  @override
  State<Writediary> createState() => _WritediaryState();
}

class _WritediaryState extends State<Writediary> {
  final _textController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  String? _selectedEmoji;
  List<String> emojis = ['😊', '😢', '😡', '😴', '😐', '😍','😂','🤪','😰','😱','🥵','🥶'];

  @override
  void dispose() {
    _textController.dispose();
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
        'timestamp': DateTime.now(),
        'user_id': user?.uid,
        'emotion': _selectedEmoji ?? '📝',
      });
      _textController.clear();
      setState(() {
        _selectedEmoji = null;
      });
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving entry: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Diary'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      backgroundColor: settings.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How was your day?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
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
            const SizedBox(height: 30),
            TextField(
              controller: _textController,
              maxLines: 5,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'What happened today?',
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                suffixIcon: IconButton(
                  onPressed: () => _textController.clear(),
                  icon: Icon(Icons.clear, color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: _saveEntry,
              minWidth: double.infinity,
              color: settings.themeColor,
              textColor: isDark ? Colors.white : Colors.black,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
