import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showEditDialog(BuildContext context, String docId, String currentEntry, String currentEmoji) {
    final TextEditingController _entryController = TextEditingController(text: currentEntry);
    final TextEditingController _emojiController = TextEditingController(text: currentEmoji);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Entry'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _emojiController,
                  decoration: const InputDecoration(labelText: 'Emoji'),
                ),
                TextField(
                  controller: _entryController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Entry'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('diary').doc(docId).update({
                  'entry': _entryController.text.trim(),
                  'emotion': _emojiController.text.trim(),
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
      drawer: NavigationDrawer(user: user),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('diary')
            .where('user_id', isEqualTo: uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No diary entries found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final entryText = data['entry'];
              final emoji = data['emotion'] ?? '📝';
              final timestamp = data['timestamp'] as Timestamp?;
              final date = timestamp?.toDate() ?? DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ExpandablePanel(
                  header: ListTile(
                    leading: Text(emoji, style: const TextStyle(fontSize: 28)),
                    title: Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  collapsed: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entryText,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  expanded: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entryText),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditDialog(context, data.id, entryText, emoji);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('diary').doc(data.id).delete();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  theme: const ExpandableThemeData(
                    hasIcon: true,
                    iconPlacement: ExpandablePanelIconPlacement.right,
                    tapHeaderToExpand: true,
                    tapBodyToCollapse: true,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/writediary');
          setState(() {});
        },
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  final User? user;
  const NavigationDrawer({super.key, required this.user});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await File(pickedFile.path).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profile_picture_base64': base64Image,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated')),
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(widget.user?.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DrawerHeader(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const DrawerHeader(
                    child: Text('User data not found'),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final name = userData['name'] ?? 'No Name';
                final email = userData['email'] ?? 'No Email';
                final base64Image = userData['profile_picture_base64'];
                final imageWidget = base64Image != null
                    ? MemoryImage(base64Decode(base64Image))
                    : const AssetImage('assets/default_profile.png') as ImageProvider;

                return buildHeader(context, name, email, imageWidget);
              },
            ),
            buildMenuItems(context),
          ],
        )),
      );

  Widget buildHeader(BuildContext context, String name, String email, ImageProvider imageProvider) => Material(
        color: Colors.pink[100],
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _pickAndUploadImage(context),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: imageProvider,
                    backgroundColor: Colors.grey[300],
                    child: imageProvider is AssetImage
                        ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(fontSize: 28)),
                Text(email, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.checklist_outlined),
            title: const Text('Goals'),
            onTap: () async {
              await Navigator.pushNamed(context, '/goalview');
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text('About Us'),
            onTap: () async {
              await Navigator.pushNamed(context, '/about');
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () async {
              await Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: (() => signout()),
          ),
          const Divider(color: Colors.black),
        ],
      );
}
