import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String street;
  final String locality;
  final String pincode;
  final String city;
  final String state;
  final String type; // e.g., 'Home', 'Office'

  Address({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.street,
    required this.locality,
    required this.pincode,
    required this.city,
    required this.state,
    required this.type,
  });

  factory Address.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Address(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      street: data['street'] ?? '',
      locality: data['locality'] ?? '',
      pincode: data['pincode'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      type: data['type'] ?? 'Other',
    );
  }
}
