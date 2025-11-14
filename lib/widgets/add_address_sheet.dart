import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddAddressSheet extends StatefulWidget {
  final Address? editAddress;

  const AddAddressSheet({super.key, this.editAddress});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final phone = TextEditingController();
  final street = TextEditingController();
  final locality = TextEditingController();
  final pincode = TextEditingController();
  final city = TextEditingController();
  final stateCtrl = TextEditingController();

  String selectedType = "Home";
  bool loading = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // If editing, fill fields
    if (widget.editAddress != null) {
      final a = widget.editAddress!;
      fullName.text = a.fullName;
      phone.text = a.phoneNumber;
      street.text = a.street;
      locality.text = a.locality;
      pincode.text = a.pincode;
      city.text = a.city;
      stateCtrl.text = a.state;
      selectedType = a.type;
    }
  }

  @override
  void dispose() {
    fullName.dispose();
    phone.dispose();
    street.dispose();
    locality.dispose();
    pincode.dispose();
    city.dispose();
    stateCtrl.dispose();
    super.dispose();
  }

  // SAVE OR UPDATE ADDRESS
  Future<void> saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final map = {
      "fullName": fullName.text.trim(),
      "phoneNumber": phone.text.trim(),
      "street": street.text.trim(),
      "locality": locality.text.trim(),
      "pincode": pincode.text.trim(),
      "city": city.text.trim(),
      "state": stateCtrl.text.trim(),
      "type": selectedType,
    };

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("addresses");

    if (widget.editAddress == null) {
      // ADD NEW
      await ref.add(map);
    } else {
      // UPDATE EXISTING
      await ref.doc(widget.editAddress!.id).update(map);
    }

    if (mounted) {
      Navigator.pop(context, true); // success
    }
  }

  Widget field(String label, TextEditingController c,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                widget.editAddress == null ? "Add Address" : "Edit Address",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              field("Full Name", fullName),
              field("Phone Number", phone, type: TextInputType.phone),
              field("Street", street),
              field("Locality", locality),
              field("Pincode", pincode, type: TextInputType.number),
              field("City", city),
              field("State", stateCtrl),

              const SizedBox(height: 10),

              // Address Type Dropdown
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ["Home", "Work", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedType = v!),
                decoration: InputDecoration(
                    labelText: "Address Type",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),

              const SizedBox(height: 20),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: saveAddress,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        widget.editAddress == null
                            ? "Save Address"
                            : "Update Address",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
