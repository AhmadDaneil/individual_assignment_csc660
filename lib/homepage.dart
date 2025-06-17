import 'package:flutter/material.dart';
import 'writediary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = List<String>.generate(10, (i) => "Item ${i + 1}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
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
        onPressed: () {
          const Writediary();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Writediary()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink[100],
        foregroundColor: Colors.lightBlue[800],
      ),
    );
  }
}