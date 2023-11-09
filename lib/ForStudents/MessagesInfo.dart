// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Message {
  Message(this.sender, this.message);

  final String message;
  final String sender;
}

class MessagesInfo extends StatefulWidget {
  const MessagesInfo({Key? key}) : super(key: key);

  @override
  _MessagesInfoState createState() => _MessagesInfoState();
}

class _MessagesInfoState extends State<MessagesInfo> {
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String studentId = prefs.getString('studentId') ?? '';

    final response =
        await http.get(Uri.parse('http://10.0.2.2/eclearanceAPI/status.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('requests')) {
        final allRequests = List<Map<String, dynamic>>.from(data['requests']);
        final matchingRequests = allRequests
            .where((request) => request['requesterStdid'] == studentId)
            .toList();

        for (final request in matchingRequests) {
          final status = request['status'];

          // Check if status is not "pending" before adding to messages
          if (status != "pending") {
            final roleName = request['roleName'];
            final title = roleName;
            final body = 'Your request has been $status';
            messages.add(Message(title, body));
          }
        }

        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
        toolbarHeight: 65,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
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
      backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold), 
                      ),
                      content: Text(messages[index].message),
                      actions: <Widget>[
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
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, 
                children: [
                  Text(
                    messages[index].sender,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
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
