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
                    Text('• 🔐 Easy Sign Up & Login : Create an account securely using your email to start your personal journaling journey.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 📝 Write Diary Entries with Emotions : Express your thoughts along with how you feel using emojis. Each entry captures your words and your mood — perfect for reflection.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 🎯 Set and Track Your Goals : Use the Goals feature to list your personal objectives and mark them as complete as you grow.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 🎨 Customize Appearance : Personalize your writing experience by changing the background color and app theme to match your mood.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
                    Text('• 🔠 Adjustable Font Size : Make your reading and writing easier by resizing the font based on your comfort.', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black,)),
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
                  'Any feedback or suggestions? We\'d love to hear from you! Please rate and review the app on the App Store or Google Play.',
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
