// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DueStatusScreen extends StatefulWidget {
  const DueStatusScreen({Key? key}) : super(key: key);

  @override

  _DueStatusScreenState createState() => _DueStatusScreenState();
}

class _DueStatusScreenState extends State<DueStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 62, 162),
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        title: Text(
          'Due Payment Status',
          style: GoogleFonts.inter(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: const DueStatusList(),
    );
  }
}

class DueStatusList extends StatefulWidget {
  const DueStatusList({Key? key}) : super(key: key);

  @override
  _DueStatusListState createState() => _DueStatusListState();
}

class _DueStatusListState extends State<DueStatusList> {
  Future<List<DueStatus>> fetchDueStatusData() async {
    final apiUrl = Uri.parse(
          'http://10.0.2.2/eclearanceAPI/status.php');
      final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Extract the 'requests' list from the response
      final List<dynamic> requests = data['requests'];

      // Parse and filter records with DueStatus = 1
      final List<DueStatus> filteredDueStatusList = requests
          .where((request) => request['DueStatus'] == '1')
          .map((request) => DueStatus.fromJson(request))
          .toList();

      return filteredDueStatusList;
    } else {
      throw Exception('Failed to load due status data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DueStatus>>(
      future: fetchDueStatusData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final dueStatus = snapshot.data![index];
              return DueStatusTile(
                dueStatus: dueStatus,
              );
            },
          );
        } else {
          return const Text('No data available.');
        }
      },
    );
  }
}

class DueStatus {
  final String requesterName;
  final String requesterStdid;
  final String requesterDepartment;
  final int dueStatus;

  DueStatus({
    required this.requesterName,
    required this.requesterStdid,
    required this.requesterDepartment,
    required this.dueStatus,
  });

  factory DueStatus.fromJson(Map<String, dynamic> json) {
    return DueStatus(
      requesterName: json['requesterName'],
      requesterStdid: json['requesterStdid'],
      requesterDepartment: json['requesterDepartment'],
      dueStatus: int.parse(json['DueStatus']),
    );
  }
}

class DueStatusTile extends StatelessWidget {
  final DueStatus dueStatus;

  const DueStatusTile({Key? key, required this.dueStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${dueStatus.requesterName}"),
            Text("Student No: ${dueStatus.requesterStdid}"),
            Text("Department: ${dueStatus.requesterDepartment}"),
          ],
        ),
      ),
    );
  }
}

