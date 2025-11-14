import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool loading = false;

  Future<void> changePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (newPass.text.trim() != confirmPass.text.trim()) {
      showMessage("New passwords do not match");
      return;
    }

    setState(() => loading = true);

    try {
      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPass.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPass.text.trim());

      setState(() => loading = false);

      showMessage("Password changed successfully");

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      setState(() => loading = false);
      showMessage(e.message ?? "Error occurred");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Old Password",
              ),
            ),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
              ),
            ),
            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm New Password",
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: changePassword,
                    child: const Text("Update Password"),
                  ),
          ],
        ),
      ),
    );
  }
}
