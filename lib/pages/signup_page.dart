import 'package:flutter/material.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/components/my_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String tag = 'signup-page'; //Tag
  
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
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
            // Username Field
            MyTextFormField(
              controller: _usernameController, 
              keyboardType: TextInputType.text, 
              obscureText: false, 
              hintText: 'Username'
            ), const SizedBox(height: 8.0),
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
            // Register Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final authService = AuthService();
                  try{
                    await authService.signUpWithEmailAndPassword(
                      _usernameController.text,
                      _emailController.text.trim(), 
                      _passwordController.text.trim()
                    );
                    Navigator.pop(context);
                  }
                  catch(e){ // Alert for put wrong input
                    // **inprogress
                    // **inprogress
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Register', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            // Go to Login page TextButton
            TextButton(
              onPressed: () { Navigator.pop(context); },
              child: const Text(
                "Already have an account? Sign in now",
                style: TextStyle(color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
}