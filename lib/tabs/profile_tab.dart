import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shreejikhakhra/screens/manage_addresses_screen.dart';
import 'package:shreejikhakhra/screens/order_history_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? _userName;
  String? _userEmail;
  String? _profilePictureUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists && mounted) {
        setState(() {
          _userName = docSnapshot.data()?['fullName'];
          _userEmail = docSnapshot.data()?['email'];
          _profilePictureUrl = docSnapshot.data()?['profilePictureUrl'];
          _isLoading = false;
        });
      }
    }
  }

  // Helper widget for creating each menu item
  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // --- USER INFO HEADER (as per your sketch) ---
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Profile Picture
                      if (_profilePictureUrl != null &&
                          _profilePictureUrl!.isNotEmpty)
                        CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_profilePictureUrl!),
                            backgroundColor: Colors.grey.shade200)
                      else
                        CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(Icons.person,
                                size: 50, color: Colors.white)),
                      const SizedBox(width: 16),
                      // Name and Email (Vertical Arrangement)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_userName != null)
                              Text(_userName!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            if (_userEmail != null)
                              Text(_userEmail!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- MENU OPTIONS ---
                _buildProfileOption(
                  context,
                  icon: Icons.list_alt_rounded,
                  title: 'My Orders',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const OrderHistoryScreen())),
                ),
                const Divider(),
                _buildProfileOption(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Manage Addresses',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ManageAddressesScreen())),
                ),
                const Divider(),
                _buildProfileOption(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  onTap: () {}, // Placeholder
                ),
                const SizedBox(height: 32),

                // --- SIGN OUT BUTTON ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    onPressed: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
