import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAddressSheet extends StatefulWidget {
  const AddAddressSheet({super.key});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _localityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _localityController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .add({
          'fullName': _nameController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'street': _streetController.text.trim(),
          'locality': _localityController.text.trim(),
          'pincode': _pincodeController.text.trim(),
          'city': _cityController.text.trim(),
          'state': _stateController.text.trim(),
          'type': 'Home',
        });

        if (mounted) {
          Navigator.pop(context, true); // Pop and signal success
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save address: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper widget to create a styled text field with a label
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'This field cannot be empty'
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text('Add Address',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name'),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _streetController,
                  label: 'Address (House No., Street)',
                  hint: 'Enter your address'),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _localityController,
                  label: 'Locality/Area',
                  hint: 'Enter your locality/area'),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _pincodeController,
                  label: 'Pincode',
                  hint: 'Enter your pincode',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'Enter your city'),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _stateController,
                  label: 'State',
                  hint: 'Enter your state'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Address'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
