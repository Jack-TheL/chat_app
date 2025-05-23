import 'package:chat_app/pages/map_page.dart';
import 'package:chat_app/pages/search_conversation_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/pages/set_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:chat_app/services/auth_gate.dart';
import 'package:chat_app/pages/signup_page.dart';
import 'package:chat_app/pages/setting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat App",
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AuthGate(),
      routes: <String,WidgetBuilder>{
        RegisterPage.tag: (context) => const RegisterPage(),
        SettingsPage.tag: (context) => const SettingsPage(),
        SetProfileIconPage.tag: (context) => const SetProfileIconPage(),
        SearchUserPage.tag: (context) => const SearchUserPage(),
        ShareLocationPage.tag: (context) => const ShareLocationPage(),
        ChatHistorySearchPage.tag: (context) => const ChatHistorySearchPage(),
      },
    );
  }
}