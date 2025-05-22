import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';

class HomePage extends StatelessWidget{
  HomePage({super.key});
  
  // chat service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: const MyDrawer(), //drawer
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(SearchUserPage.tag);
            }, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: _buildUserList(),  // Display all users except current user
    );
  }

  // buil list of users excapt current user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context, snapshot) {
        // if error
        if(snapshot.hasError){ return const Text("Error");}
        // if loading 
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading...");
        }
        // get list of users
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }

  // buil list tile of each user 
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
    // display all users except current user
    if(userData["uid"] != _authService.getCurrentUser()!.uid){
      return UserTile(
        text: userData["username"],
        onTap: (){ 
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
            ChatPage(receiverUsername: userData["username"], receiverID: userData["uid"],),),);
        },
      );
    } else { return Container(); }
  }
}