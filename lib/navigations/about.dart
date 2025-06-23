import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 eDiary',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'eDiary is a personal digital diary app that lets you capture your daily thoughts, moods, and experiences in a simple and expressive way. '
              'Whether you\'re feeling happy, sad, tired, or neutral, eDiary provides an easy way to write about your day and associate each entry with a mood emoji.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Key Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('• ✍️ Write Daily Entries : Reflect on your day and write freely in your own words.', style: TextStyle(fontSize: 16)),
            Text('• 😊 Express Emotions with Emojis : Choose from a variety of emojis to represent how you felt.', style: TextStyle(fontSize: 16)),
            Text('• 📅 Date Tracking : Each entry is automatically timestamped and organized by date.', style: TextStyle(fontSize: 16)),
            Text('• 🔐 Secure and Private : Your entries are safely stored in the cloud and linked to your account.', style: TextStyle(fontSize: 16)),
            Text('• 🔄 Access Anywhere : Sign in from any device and view your diary from anywhere at any time.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
              'eDiary is designed for simplicity and self-expression, helping you build a healthy habit of reflection and mindfulness.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        )
    );
  }
}