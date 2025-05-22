import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  // auth & firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() { return _auth.currentUser;}

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(String email,password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password,);
      return userCredential;
    } on FirebaseAuthException catch(e){ throw Exception(e.code); }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(String username, email,password) async {
    try{ // create user with email & password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      
      // save user info into firestore
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'username' : username,
        }
      );
      
      return userCredential;
    } on FirebaseAuthException catch(e){ throw Exception(e.code); }
  }

  // sign out
  Future<void> singOut() async { return await _auth.signOut();}

  /// get User uid for firestore
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('Users').doc(uid).get();
  }
  // error
}