import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {

  Future<String?> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {

    UserCredential  user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.user!.uid;
  }


  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String?> currentUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }


  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}