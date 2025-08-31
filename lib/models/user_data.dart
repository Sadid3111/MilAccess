import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData {
  static String status = 'unauthenticated';
  static String name = '';
  static String email = '';
  static String role = '';
  static String uid = '';
  static String unitName = '';

  static void reset() {
    status = 'unauthenticated';
    name = '';
    email = '';
    role = '';
    uid = '';
    unitName = '';
  }
}

void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  UserData.reset();
  Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
}
