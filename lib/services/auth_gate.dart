import 'package:chat_app/services/switcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/pages/signin_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){ 
          //if User logged in
          if(snapshot.hasData){ return const Switcher();}
          //if User not log in
          else{ return const LoginPage();}
        }
      ),
    );
  }
}