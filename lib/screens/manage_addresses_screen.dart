import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';
import '../widgets/add_address_sheet.dart';

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({super.key});

  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  List<Address> _addresses = [];
  bool _isLoading = true;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    if (user == null) return;

    setState(() => _isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("addresses")
        .get();

    setState(() {
      _addresses =
          snapshot.docs.map((doc) => Address.fromFirestore(doc)).toList();
      _isLoading = false;
    });
  }

  // DELETE ADDRESS
  Future<void> _deleteAddress(String id) async {
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("addresses")
        .doc(id)
        .delete();

    _fetchAddresses();
  }

  // POPUP CONFIRMATION
  void _confirmDelete(Address address) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Address?"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
            onPressed: () {
              Navigator.pop(context);
              _deleteAddress(address.id);
            },
          ),
        ],
      ),
    );
  }

  // OPEN ADD / EDIT SHEET
  void _openSheet({Address? edit}) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddAddressSheet(editAddress: edit),
    );

    if (result == true) {
      _fetchAddresses(); // Refresh after save
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Addresses")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSheet(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? const Center(
                  child: Text("No addresses added yet."),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _addresses.length,
                  itemBuilder: (_, index) {
                    final address = _addresses[index];

                    return Dismissible(
                      key: Key(address.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        bool confirm = false;

                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Address"),
                            content: const Text(
                                "Are you sure you want to delete this address?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text("Delete"),
                                onPressed: () {
                                  confirm = true;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );

                        return confirm;
                      },
                      onDismissed: (_) => _deleteAddress(address.id),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            address.fullName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "${address.street}, ${address.locality}\n"
                            "${address.city} • ${address.state} • ${address.pincode}\n"
                            "📞 ${address.phoneNumber}  •  ${address.type}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(address),
                          ),
                          onTap: () => _openSheet(edit: address), // EDIT
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
