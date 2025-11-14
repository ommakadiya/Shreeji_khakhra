// lib/screens/profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../services/storage_service.dart';
import '../services/auth_service.dart';
import 'manage_addresses_screen.dart';
import 'order_history_screen.dart';
import 'change_password_screen.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? photoUrl;

  bool loading = true;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Load user data
  Future<void> loadUserData() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        name = doc["name"];
        email = doc["email"];
        photoUrl = doc["photoUrl"];
        loading = false;
      });
    } else {
      setState(() {
        name = user!.displayName ?? "";
        email = user!.email ?? "";
        photoUrl = user!.photoURL;
        loading = false;
      });
    }
  }

  // Upload new profile photo
  Future<void> uploadNewImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    File file = File(picked.path);

    String? imageUrl = await StorageService().uploadProfilePhoto(file);

    if (imageUrl == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({"photoUrl": imageUrl});

    setState(() => photoUrl = imageUrl);
  }

  // Edit Name Dialog
  void editNameDialog() {
    TextEditingController controller = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Name"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .update({"name": controller.text});

                setState(() => name = controller.text);

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // LOGOUT — FIXED
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: uploadNewImage,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                    ? NetworkImage(photoUrl!)
                    : null,
                child: (photoUrl == null || photoUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 55)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name ?? "No Name",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              email ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: editNameDialog,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Name"),
            ),
            const SizedBox(height: 30),
            buildOption(
              icon: Icons.list_alt,
              title: "My Orders",
              page: const OrderHistoryScreen(),
            ),
            buildOption(
              icon: Icons.location_on,
              title: "Manage Addresses",
              page: const ManageAddressesScreen(),
            ),
            buildOption(
              icon: Icons.lock,
              title: "Change Password",
              page: const ChangePasswordScreen(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption({
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
