import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:individual_assignment/navigations/settings/settings_provider.dart';
import 'package:individual_assignment/app_colors.dart';


class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  void _loadUserSettings() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? '';
        Provider.of<SettingsProvider>(context, listen: false).loadFromMap(data);
      }
    }
  }

  Future<void> _saveSettings() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'name': _nameController.text.trim(),
      ...settings.toMap(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved.')));
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(onPressed: _saveSettings, icon: const Icon(Icons.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
  color: isDark ? AppColors.darkCard : AppColors.lightCard,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Name',
          style: TextStyle(
            fontSize: settings.fontSize,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        TextField(
          controller: _nameController,
          style: TextStyle(
            fontSize: settings.fontSize,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[700] : Colors.white,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    ),
  ),
),

          const SizedBox(height: 24),

          Card(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            child: SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black)),
              value: settings.isDarkMode,
              onChanged: settings.updateDarkMode,
            ),
          ),
          const SizedBox(height: 24),

          Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Font Size', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black)),
                  Slider(
                    value: settings.fontSize,
                    min: 12,
                    max: 30,
                    divisions: 6,
                    label: settings.fontSize.round().toString(),
                    onChanged: settings.updateFontSize,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Background Color', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black)),
                Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                 _colorBox(settings, Colors.pink),
                 _colorBox(settings, Colors.blue),
                 _colorBox(settings, Colors.green),
                 _colorBox(settings, Colors.orange),
                 _colorBox(settings, Colors.purple),
                 _colorBox(settings, Colors.yellow),
                 _colorBox(settings, Colors.lime),
                 _colorBox(settings, Colors.teal),
                 _colorBox(settings, Colors.cyan),
                 _colorBox(settings, Colors.indigo),
                 _colorBox(settings, Colors.brown),
                 _colorBox(settings, Colors.red),
                 _colorBox(settings, Colors.blueGrey),
                ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

                  Card(
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Appbar Color', style: TextStyle(fontSize: settings.fontSize, color: isDark ? Colors.white : Colors.black)),
                Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                _colorBox(settings, Colors.pink, isAppBar: true),
                _colorBox(settings, Colors.blue, isAppBar: true),
                _colorBox(settings, Colors.green, isAppBar: true),
                _colorBox(settings, Colors.orange, isAppBar: true),
                _colorBox(settings, Colors.purple, isAppBar: true),
                _colorBox(settings, Colors.yellow, isAppBar: true),
                _colorBox(settings, Colors.lime, isAppBar: true),
                _colorBox(settings, Colors.teal, isAppBar: true),
                _colorBox(settings, Colors.cyan, isAppBar: true),
                _colorBox(settings, Colors.indigo, isAppBar: true),
                _colorBox(settings, Colors.brown, isAppBar: true),
                _colorBox(settings, Colors.red, isAppBar: true),
                _colorBox(settings, Colors.blueGrey, isAppBar: true),
                ],
                ),
              ],
            ),
          ),
        ),

        ],
      ),
    );
  }

Widget _colorBox(SettingsProvider settings, Color color, {bool isAppBar = false}) {
  return GestureDetector(
    onTap: () {
      if (isAppBar) {
        settings.updateAppBarColor(color);
      } else {
        settings.updateBackgroundColor(color);
      }
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: isAppBar
              ? (settings.appBarColor == color ? Colors.black : Colors.grey)
              : (settings.backgroundColor == color ? Colors.black : Colors.grey),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
  Widget _themeColorCircle(SettingsProvider settings, MaterialColor color) {
  return GestureDetector(
    onTap: () => settings.updateThemeColor(color),
    child: CircleAvatar(
      backgroundColor: color,
      child: settings.themeColor == color
          ? const Icon(Icons.check, color: Colors.white)
          : null,
    ),
  );
}
}