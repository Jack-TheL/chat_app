import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHistorySearchPage extends StatefulWidget {
   static String tag = 'search-conversation-page';
  const ChatHistorySearchPage({super.key});

  @override
  State<ChatHistorySearchPage> createState() => _ChatHistorySearchPageState();
}

class _ChatHistorySearchPageState extends State<ChatHistorySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _searchStream;

  @override
  void initState() {
    super.initState();
    _searchStream = FirebaseFirestore.instance.collection('chat_history').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter keywords...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchStream = FirebaseFirestore.instance.collection('chat_history')
                      .where('message', isGreaterThanOrEqualTo: value)
                      .where('message', isLessThanOrEqualTo: value + '\uf8ff')
                      .snapshots();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _searchStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No chat history found.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var chatData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(chatData['message']),
                      subtitle: Text(chatData['timestamp'].toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
