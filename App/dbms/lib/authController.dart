import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'wrapper.dart';
import 'utils/validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'models/user.dart';

class AuthController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String downloadUrl = '';

  Users _userFromFirebaseUser(User user) {
    return user != null
        ? Users(
            uid: _auth.currentUser.uid,
            firstname: _auth.currentUser.displayName,
            imageUrl: downloadUrl)
        : null;
  }

  Stream<Users> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Validator validator = Validator();

  // Create User
  Future createUser(
      {String firstname,
      String lastname,
      String mobilenumber,
      String email,
      String password,
      String type}) async {
    try {
      if (email != '' &&
          password != '' &&
          firstname != '' &&
          lastname != '' &&
          mobilenumber != '') {
        Get.snackbar('Signing Up', 'Please wait...',
            icon: Icon(FontAwesomeIcons.pen),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 3),
            overlayBlur: 1);
      }
      if (validator.validateEmail(email) == null &&
          validator.validatePasswordLength(password) == null &&
          validator.validateName(firstname) == null &&
          validator.validateName(lastname) == null &&
          validator.validateMobile(mobilenumber) == null) {
        CollectionReference reference =
            FirebaseFirestore.instance.collection("Users");
        var result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        var user = result.user;
        // updateInfo.displayName = _usernameController.text;
        // user.updateProfile(updateInfo);
        await reference.doc(user.uid).set({
          "First Name": firstname,
          "Last Name": lastname,
          "Mobile Number": mobilenumber,
          "Email": email,
          "Type": type,
        });
        // var updateInfo = user.updateProfile(displayName: firstname);

        Get.offAll(Wrapper());
      } else {
        Get.snackbar('Please fill', 'All details correct',
            icon: Icon(FontAwesomeIcons.pen),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 3),
            overlayBlur: 1);
      }

      return user;
    } catch (e) {
      Get.snackbar(
        "Error while Signing Up",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
        overlayBlur: 1,
      );
      return null;
    }
  }

  // User Login
  Future login({String email, String password}) async {
    try {
      if (email != '' && password != '') {
        Get.snackbar('Signing In', 'Please wait...',
            icon: Icon(FontAwesomeIcons.pen),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 3),
            overlayBlur: 1);
      }

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      /*CollectionReference reference = FirebaseFirestore.instance
          .collection("Users")
          .doc(_auth.currentUser.uid)
          .get()
          .then((value) {
        value.data().entries.forEach((element) {
          if (element.key == "Image") downloadUrl = element.value;
        });
      }) as CollectionReference;*/
      User user = result.user;
      return user;
    } catch (e) {
      Get.snackbar(
        "Error while Signing In",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 3),
        overlayBlur: 1,
      );
      return null;
    }
  }

  // User Signout
  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Get.snackbar(
        "Error while signing out",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent,
        overlayBlur: 1,
      );
      print(e);
      return null;
    }
  }

  Future reset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((e) => Get.snackbar(
            "Email Send",
            "Please Check Your Email",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 3),
            overlayBlur: 1,
          ));
    } catch (e) {
      Get.snackbar(
        "Error while Sending Email",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 3),
        overlayBlur: 1,
      );
    }
  }
}
