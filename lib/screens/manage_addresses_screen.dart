import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shreejikhakhra/models/address_model.dart';
import 'package:shreejikhakhra/widgets/add_address_sheet.dart';

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  List<Address> _addresses = [];
  String? _selectedAddressId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .get();
      setState(() {
        _addresses =
            snapshot.docs.map((doc) => Address.fromFirestore(doc)).toList();
        if (_addresses.isNotEmpty) {
          _selectedAddressId = _addresses.first.id;
        }
        _isLoading = false;
      });
    }
  }

  void _showAddAddressSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const AddAddressSheet(),
    );
    if (result == true) {
      _fetchAddresses(); // Refresh the list if an address was added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Shipping Address')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: RadioListTile<String>(
                          title: Text(address.type,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${address.street}, ${address.locality}, ${address.city}, ${address.state} - ${address.pincode}'),
                          value: address.id,
                          groupValue: _selectedAddressId,
                          onChanged: (value) =>
                              setState(() => _selectedAddressId = value),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add New Address'),
                  onTap: _showAddAddressSheet,
                ),
              ],
            ),
    );
  }
}
