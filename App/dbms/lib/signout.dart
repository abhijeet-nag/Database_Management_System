import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authController.dart';

class Signout extends StatefulWidget {
  @override
  _SignoutState createState() => _SignoutState();
}

class _SignoutState extends State<Signout> {
  final AuthController _auth = AuthController();

  final FirebaseAuth authe = FirebaseAuth.instance;

  final databaseReference = FirebaseFirestore.instance;

  getCurrentUser() async {
    final User user = authe.currentUser;
    print(user);
  }

  Search search = Search();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: () {
              _auth.signOut();
            },
            child: Text(
              "Signout",
              style: TextStyle(fontSize: 20, color: Colors.deepOrange),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          )
        ],
      ),
      body: search,
    );
  }
}
