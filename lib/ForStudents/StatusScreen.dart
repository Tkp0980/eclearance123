// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, Key? key1});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData when the widget is initialized
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String studentId = prefs.getString('studentId') ?? '';
    

    final response =
        await http.get(Uri.parse('http://10.0.2.2/eclearanceAPI/status.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Debug print

      if (data.containsKey('requests')) {
        final allRequests = List<Map<String, dynamic>>.from(data['requests']);
        final matchingRequests = allRequests
            .where((request) => request['requesterStdid'] == studentId)
            .toList();

        setState(() {
          requests = matchingRequests;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 62, 162),
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        title: Text(
          'Status',
          style: GoogleFonts.inter(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
      body: Center(
        child: requests.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${request['roleName']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Requester Name: ${request['requesterName']}'),
                          Text('Requester ID: ${request['requesterStdid']}'),
                          Text(
                              'Requester Department: ${request['requesterDepartment']}'),
                          Text('Status: ${request['status']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
