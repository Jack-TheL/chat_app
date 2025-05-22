import 'package:chat_app/components/my_drawer.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("Notification"),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final snackBar = SnackBar(
              content: const Text('This is a notification!'),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                  // ปิด Notification
                },
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }
}
