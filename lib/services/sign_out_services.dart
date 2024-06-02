import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignOutService {
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
