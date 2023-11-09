// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message {
  Message(this.sender, this.message, this.isUnread);

  final bool isUnread; // Add a flag for unread messages
  final String message;
  final String sender;
}

class MessagesInfo extends StatelessWidget {
  MessagesInfo({Key? key}) : super(key: key);

  final List<Message> messages = [
    Message('Sender 1', 'Message 1 content', true), // Mark this message as unread
    Message('Sender 2', 'Message 2 content', false),
    // Add more messages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 62, 162),
        toolbarHeight: 65,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the start and end
          children: [
            Text(
              'Notifications:',
              style: GoogleFonts.inter(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 62, 162),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            child: ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        messages[index].sender,
                        style: const TextStyle(fontWeight: FontWeight.bold), // Bold sender name
                      ),
                      content: Text(messages[index].message),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the start and end
                children: [
                  Text(
                    messages[index].sender,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (messages[index].isUnread)
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(left: 8), // Adjust margin to move the indicator to the right
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 68, 68), // Indicator color
                      ),
                    ),
                ],
              ),
              subtitle: Text(messages[index].message),
            ),
          );
        },
      ),
    );
  }
}
