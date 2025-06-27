import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:individual_assignment/navigations/settings/settings_provider.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      backgroundColor: settings.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: theme.cardColor,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '📝 eDiary',
                  style: TextStyle(
                    fontSize: settings.fontSize + 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              color: theme.cardColor,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'eDiary is a personal digital diary app that lets you capture your daily thoughts, moods, and experiences in a simple and expressive way. Whether you\'re feeling happy, sad, tired, or neutral, eDiary provides an easy way to write about your day and associate each entry with a mood emoji.',
                  style: TextStyle(
                    fontSize: settings.fontSize,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: theme.cardColor,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Features:',
                      style: TextStyle(
                        fontSize: settings.fontSize + 4,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('• ✍️ Write Daily Entries : Reflect on your day and write freely in your own words.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 😊 Express Emotions with Emojis : Choose from a variety of emojis to represent how you felt.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 📅 Date Tracking : Each entry is automatically timestamped and organized by date.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 🔐 Secure and Private : Your entries are safely stored in the cloud and linked to your account.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 🔄 Access Anywhere : Sign in from any device and view your diary from anywhere at any time.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: theme.cardColor,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'eDiary is designed for simplicity and self-expression, helping you build a healthy habit of reflection and mindfulness.',
                  style: TextStyle(
                    fontSize: settings.fontSize,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
