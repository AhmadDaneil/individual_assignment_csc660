import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'goalcreate.dart';

class Goalsview extends StatefulWidget {
  const Goalsview({super.key});

  @override
  State<Goalsview> createState() => _GoalsviewState();
}

class _GoalsviewState extends State<Goalsview> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('Please log in.'));

    final goalsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('goals')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('My Goals')),
      body: StreamBuilder<QuerySnapshot>(
        stream: goalsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final goals = snapshot.data!.docs;

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final data = goals[index];
              final isCompleted = data['isCompleted'] as bool;
              return Dismissible(
  key: Key(data.id),
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  secondaryBackground: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  onDismissed: (direction) async {
    await data.reference.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Goal "${data['title']}" deleted')),
    );
  },
  child: ListTile(
    title: Text(
      data['title'],
      style: TextStyle(decoration: isCompleted ? TextDecoration.lineThrough : null),
    ),
    subtitle: Text(data['description']),
    trailing: Checkbox(
      value: isCompleted,
      onChanged: (val) {
        data.reference.update({'isCompleted': val});
      },
    ),
  ),
);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Goalcreate()),
          );
        },
      ),
    );
  }
}
