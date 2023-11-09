import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, Key? key1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 65,
        backgroundColor: const Color(0xFFB0B3BF),
      ),
      backgroundColor: const Color(0xff2a54d5),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data['requests'].length,
              itemBuilder: (context, index) {
                final request = data['requests'][index];
                if (request['buttonClicked'] == "1") {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        '${request['requesterName']} - ${request['requesterDepartment']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Status: ${request['status']}',
                            style: const TextStyle(
                             
                              fontSize: 16,
                              color: Colors.green, // Adjust the color as needed
                            ),
                          ),
                          Text(
                            'Std ID: ${request['requesterStdid']}',
                            style: const TextStyle(
                             
                              fontSize: 16,
                              color: Colors.green, // Adjust the color as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink(); // Hide items with buttonClicked != 1
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<dynamic> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/eclearanceAPI/status.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
