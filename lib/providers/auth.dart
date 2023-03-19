import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management_app/models/product.dart';
import '../models/user.dart';

class Auth with ChangeNotifier {
  List<Product> _productList = [];

  List<Product> get productItem {
    return [..._productList];
  }

  Product findProductById(String productId) {
    return _productList.firstWhere((product) => product.productId == productId);
  }



  Future<void> saveRegistration(
    UserModel user,
  ) async {
    final _auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(
        {
          'userName': user.userName,
          'email': user.email,
          'password': user.password,
          'phoneNumber': user.phoneNumber,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> loginWithEmailAndPassword(UserModel user) async {
    final _auth = FirebaseAuth.instance;
    UserCredential userCredential;

    userCredential = await _auth.signInWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
  }
}
