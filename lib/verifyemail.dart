import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:individual_assignment/wrapper.dart';
import 'package:get/get.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  void initState() {
    super.initState();
    sendVerifyLink();
  }

  Future<void> sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((_) {
      Get.snackbar(
        'Link Sent',
        'A link has been sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.pink[100],
        colorText: Colors.black,
      );
    });
  }

  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      Get.offAll(() => Wrapper());
    } else {
      Get.snackbar(
        'Not Verified',
        'Your email is still not verified.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification")),
      body: const Padding(
        padding: EdgeInsets.all(28.0),
        child: Center(
          child: Text(
            "Open your email and click on the link provided to verify your account. Then tap the reload button.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton(
      onPressed: reload,
      tooltip: 'Reload',
      child: const Icon(Icons.restart_alt_rounded),
    ),
    const SizedBox(height: 16),
    FloatingActionButton(
      backgroundColor: Colors.redAccent,
      tooltip: 'Cancel and Logout',
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => Wrapper()); // Redirect back to Wrapper/Login
      },
      child: const Icon(Icons.logout),
    ),
  ],
),
    );
  }
}
