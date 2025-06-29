import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:individual_assignment/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> _handleRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showEditDialog(BuildContext context, String docId, String currentEntry, String currentEmoji) {
    final TextEditingController entryController = TextEditingController(text: currentEntry);
    final TextEditingController emojiController = TextEditingController(text: currentEmoji);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Entry'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: emojiController,
                  decoration: const InputDecoration(labelText: 'Emoji'),
                ),
                TextField(
                  controller: entryController,
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
                  'entry': entryController.text.trim(),
                  'emotion': emojiController.text.trim(),
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
    final user = FirebaseAuth.instance.currentUser;
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
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
            return const Center(child: SpinKitSquareCircle(
              color: Colors.purple,
              size: 50.0,
            ));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No diary entries found.'));
          }

          return LiquidPullToRefresh(
  onRefresh: _handleRefresh,
  color: Colors.purple,
  height: 120,
  animSpeedFactor: 2,
  backgroundColor: Colors.white,
  showChildOpacityTransition: false,
  child: ListView.builder(
    itemCount: docs.length,
    itemBuilder: (context, index) {
      final data = docs[index];
      final entryText = data['entry'];
      final emoji = data['emotion'] ?? '📝';
      final timestamp = data['timestamp'] as Timestamp?;
      final date = timestamp?.toDate() ?? DateTime.now();

      return Card(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: ExpandablePanel(
          header: ListTile(
            leading: Text(
              emoji,
              style: TextStyle(
                fontSize: 28,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            title: Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          collapsed: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              entryText,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          expanded: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entryText,
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
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
                        final deletedData = data.data();
                        await FirebaseFirestore.instance
                            .collection('diary')
                            .doc(data.id)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Entry deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('diary')
                                    .doc(data.id)
                                    .set(deletedData as Map<String, dynamic>);
                              },
                            ),
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/writediary');
          setState(() {});
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.user?.uid).snapshots(),
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
          onTap: () => _pickAndUploadImage(context),
          splashColor: Colors.white,
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
