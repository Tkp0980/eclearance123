import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message {
  final String topic;
  final String content;
  final DateTime timestamp; // Add a timestamp property

  Message({
    required this.topic,
    required this.content,
    required this.timestamp,
  });
}

// ignore: must_be_immutable
class DuesDetailPage extends StatelessWidget {
  DuesDetailPage({super.key, Key? key2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dues',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 65,
        backgroundColor: const Color(0xFFB0B3BF),
      ),
      backgroundColor: const Color(0xff2a54d5),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for more spacing
        child: ListView.separated(
          itemCount: messages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20), // Add more space between messages
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              padding: const EdgeInsets.all(16.0), // Add internal padding
              child: ListTile(
                onTap: () {
                  _showMessageDialog(context, messages[index]); // Pass context
                },
                title: Text(
                  messages[index].topic,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messages[index].content,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${messages[index].timestamp}', // Display the timestamp
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Message> messages = [
    Message(
      topic: "Lab 1",
      content: "You have dues amounting to nu 500. Please upload screenshot to this account 203838384",
      timestamp: DateTime.now(), // Set a timestamp
    ),
    Message(
      topic: "Message 2",
      content: "This is the content of Message 2.",
      timestamp: DateTime.now(), // Set a timestamp
    ),
    // Add more messages as needed
  ];

  void _showMessageDialog(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message.topic,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(message.content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Implement photo upload functionality
              },
              child: const Text('Upload Payment'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
