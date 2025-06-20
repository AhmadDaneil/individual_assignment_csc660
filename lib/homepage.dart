import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final items = List<String>.generate(10, (i) => "Item ${i + 1}");

  final user=FirebaseAuth.instance.currentUser;

  signout()async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
      drawer:NavigationDrawer(user: user),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(items[index]),
              leading: const Icon(Icons.note),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle item tap
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on ${items[index]}')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.pushNamed(context, '/writediary');
          
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
            await Navigator.pushNamed(context, '/home');
          },
        ),
        const Divider(color: Colors.black),
        ListTile(
          leading: const Icon(Icons.book_outlined),
          title: const Text('Your Diary'),
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