import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget{
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  const MyTextFormField({super.key, required this.controller, 
    required this.keyboardType, required this.obscureText, required this.hintText});
  
  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: false,
      initialValue: null,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }
}