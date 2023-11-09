// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DuesDetailPage extends StatefulWidget {
  const DuesDetailPage({super.key, Key? key2});

  @override
  _DuesDetailPageState createState() => _DuesDetailPageState();
}

class _DuesDetailPageState extends State<DuesDetailPage> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    loadDues();
  }

  Future<void> loadDues() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('studentId');

    final response =
        await http.get(Uri.parse('http://10.0.2.2/eclearanceAPI/status.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final requests = data['requests'];

      List<Message> dueMessages = [];

      for (var request in requests) {
        if (request['requesterStdid'] == studentId) {
          if (request['DueMessage'] == 'message') {
            continue;
          }

          dueMessages.add(Message(
            topic: request['roleName'],
            content: request['DueMessage'],
            timestamp: DateTime.now(),
          ));
        }
      }

      setState(() {
        messages = dueMessages;
      });
    } else {
      // Handle API error
    }
  }

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
        backgroundColor:const Color(0xFFB0B3BF),
      ),
      backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: messages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                onTap: () {
                  _showMessageDialog(context, messages[index]);
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
                      '${messages[index].timestamp}',
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
                markAsPaid(message.topic); // Pass the role name to mark as paid
                Navigator.of(context).pop();
              },
              child: const Text('Mark As Paid'),
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

  void markAsPaid(String roleName) async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('studentId');

    // You need to implement the API call here to mark as paid using studentId and roleName.
    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2/eclearanceAPI/markaspaid'), // Replace with your API URL
      body: {
        'studentId': studentId, // Pass the student ID
        'roleName': roleName, // Pass the role name
      },
    );

    if (response.statusCode == 200) {
      print("it worked");
    } else {
      print("error");

      // Handle API error
      // You can add error handling code here.
    }

    // Reload dues after marking as paid
    loadDues();
  }
}

class Message {
  final String topic;
  final String content;
  final DateTime timestamp;

  Message({
    required this.topic,
    required this.content,
    required this.timestamp,
  });
}
