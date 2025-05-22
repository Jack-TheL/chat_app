import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // auth & firestore instace
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data(); // get each users data
        return user; // add to list
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async{
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
      senderID: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timestamp: timestamp
    );

    // construct chat room ID for 2 users
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //sort id for ensure that the chatroomID is the same for 2 people
    String chatRoomID = ids.join('_');

    // add new new message to firestore
    await _firestore.collection("chat_rooms").doc(chatRoomID)
      .collection("messages").add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessage(String userID, otherUserID) {
    // construct chat room ID for 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort(); //sort id for ensure that the chatroomID is the same for 2 people
    String chatRoomID = ids.join('_');

    return _firestore.collection("chat_rooms").doc(chatRoomID)
      .collection("messages").orderBy("timestamp", descending: false)
      .snapshots();
  }
}