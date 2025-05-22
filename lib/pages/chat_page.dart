import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/pages/map_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUsername;
  final String receiverID;
  const ChatPage({super.key, required this.receiverUsername, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  //////// auto scoll message down
  FocusNode myFocusNode = FocusNode();
  
  @override
  void initState(){
    super.initState();
    // add lis
    myFocusNode.addListener(() { 
      if(myFocusNode.hasFocus){
        //
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    // wait for buil list and then scroll down
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn
    );
  }
  // send message method
  void sendMessage() async {
    // if box not empty send message 
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear(); // clear input box
    }
  }
  // UI
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUsername),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userID: widget.receiverID,),),);
            },
            icon: const Icon(Icons.account_circle),
          ),
          IconButton(
            onPressed: (){Navigator.of(context).pushNamed(ShareLocationPage.tag);},
            icon: const Icon(Icons.location_on),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(),), //display all message
          _builUserInput(), // user input
        ],
      ),
    );
  }

  // message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverID, senderID), 
      builder: (context, snapshot) {
        //error
        if(snapshot.hasError){return const Text("error");}
        //loading
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        //return chat list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // buil message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // if sendder not a current user message show left
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
        ],
      ),
    );
  }

  // build message input
  Widget _builUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          //send icon button
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage, 
              icon: const Icon(Icons.arrow_forward, 
                color: Colors.white,)))
        ],
      ),
    );
  }
}