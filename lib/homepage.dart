import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user=FirebaseAuth.instance.currentUser;

  signout()async{
    await FirebaseAuth.instance.signOut();
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
      drawer:NavigationDrawer(user: user),

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
          child: ListTile(
            leading: Text(emoji, style: const TextStyle(fontSize: 28)),
            title: Text(entryText),
            subtitle: Text('${date.toLocal().toString().split(' ')[0]}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Optional: Handle item tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on entry from ${date.toLocal().toString().split(' ')[0]}')),
              );
            },
          ),
        );
      },
    );
  },
),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.pushNamed(context, '/writediary');
          setState(() {
            // Refresh the state to show the new entry
          });
          
        },
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
final User? user;

  const NavigationDrawer({super.key, required this.user});

  Future<void> signout() async {
  await FirebaseAuth.instance.signOut();
}

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          buildMenuItems(context),
        ],
      )
    ),
    );
    Widget buildHeader(BuildContext context) => Material(
      color: Colors.pink[100],
      child: InkWell(
        onTap: () {},
        child: Container(
      padding: EdgeInsets.only(
        top:24 + MediaQuery.of(context).padding.top,
        bottom: 24,
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(""),
          ),
          const SizedBox(height: 12,),
          Text('${user?.displayName ?? "No name"}',
            style: const TextStyle(fontSize: 28,),
            ),
          Text('${user?.email ?? "No email"}',
            style: const TextStyle(fontSize: 16,),
          ),
          
        ],
      ),
      ),
      ),
    );

    Widget buildMenuItems(BuildContext context) => Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () async{
          },
        ),
        const Divider(color: Colors.black),
        ListTile(
          leading: const Icon(Icons.book_outlined),
          title: const Text('About Us'),
          onTap: (){},
        ),
        const Divider(color: Colors.black),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () async{
            await Navigator.pushNamed(context, '/settings');
          },
        ),
        const Divider(color: Colors.black),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: (()=>signout()),
        ),
        const Divider(color: Colors.black),
      ],
    );
}