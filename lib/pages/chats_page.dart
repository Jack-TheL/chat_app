import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/services/chat_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late ChatService _chatService;
  late FirebaseAuth _auth;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _auth = FirebaseAuth.instance;
    _currentUser = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(SearchUserPage.tag);
            }, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Map<String, dynamic>> users = snapshot.data!;
          List<Widget> userWidgets = [];
          for (var user in users) {
            Widget userWidget = _buildUserTile(user);
            userWidgets.add(userWidget);
          }
          return ListView(
            children: userWidgets,
          );
        },
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    return StreamBuilder(
      stream: _chatService.getMessage(_currentUser.uid, user['uid']),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        List<QueryDocumentSnapshot> messages = snapshot.data!.docs;
        if (messages.isEmpty) {
          return const SizedBox();
        }
        String lastMessage = messages.last['message'];
        return ListTile(
          leading: CircleAvatar(
            // You can load profile image here if available
            child: Text(user['username'][0]), // Display profile
          ),
          title: Text(user['username']),
          subtitle: Text(lastMessage),
          onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => 
                ChatPage(receiverUsername: user["username"], receiverID: user["uid"],),),);
          },
        );
      },
    );
  }
}
