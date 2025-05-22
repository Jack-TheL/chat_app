import 'package:flutter/material.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/components/my_text_form_field.dart';
import 'package:chat_app/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // User Icon
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child: Image.asset('assets/userIcon.png'),
            ), const SizedBox(height: 48.0),
            // Email Field
            MyTextFormField(
              controller: _emailController, 
              keyboardType: TextInputType.emailAddress, 
              obscureText: false, 
              hintText: 'Email'
            ), const SizedBox(height: 8.0),
            // Password Field
            MyTextFormField(
              controller: _passwordController, 
              keyboardType: TextInputType.text, 
              obscureText: true, 
              hintText: 'Password'
            ), const SizedBox(height: 24.0),
            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final authService = AuthService();
                  try{
                    await authService.signInWithEmailAndPassword(
                      _emailController.text, _passwordController.text,
                    );
                  }
                  catch (e){ // Alert for put wrong input
                    /// ***In progress
                    /// ***In progress
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Log In', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            // Go to register page TextButton
            TextButton(
              onPressed: () {Navigator.of(context).pushNamed(RegisterPage.tag); },
              child: const Text(
                "Don't have an account? Register now",
                style: TextStyle(color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
}