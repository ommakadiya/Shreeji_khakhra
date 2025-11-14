import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTER USER
  Future<String?> register(String email, String password) async {
    try {
      // Create user in FirebaseAuth
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCred.user;

      // Create Firestore User Document
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "name": "",
          "email": email,
          "photoUrl": "",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN USER
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCred.user;

      // Ensure Firestore document exists
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (!doc.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "name": user.displayName ?? "",
            "email": user.email ?? email,
            "photoUrl": user.photoURL ?? "",
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }

      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT USER
  Future<void> logout() async {
    await _auth.signOut();
  }
}
