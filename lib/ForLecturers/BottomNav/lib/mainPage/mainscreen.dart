// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenLec extends StatefulWidget {
  const MainScreenLec({Key? key}) : super(key: key);

  @override
  _MainScreenLecState createState() => _MainScreenLecState();
}

class _MainScreenLecState extends State<MainScreenLec>
    with AutomaticKeepAliveClientMixin<MainScreenLec> {
  @override
  bool get wantKeepAlive => true;

  List<DueRequest> dueRequests = [];

  @override
  void initState() {
    super.initState();
    loadData();
    fetchData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRequests = prefs.getStringList('dueRequests');
    if (savedRequests != null) {
      final List<DueRequest> loadedRequests = savedRequests
          .map((data) => DueRequest.fromJson(json.decode(data)))
          .toList();
      setState(() {
        dueRequests = loadedRequests;
      });
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final requestList =
        dueRequests.map((request) => json.encode(request.toJson())).toList();
    prefs.setStringList('dueRequests', requestList);
  }

  void addDueRequest(DueRequest request) {
    setState(() {
      dueRequests.add(request);
      saveData(); // Save data when a new request is added
    });
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail');

    final response =
        await http.get(Uri.parse('http://10.0.2.2/eclearanceAPI/status.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final requests = data['requests'];
      List<DueRequest> updatedRequests = [];

      for (var request in requests) {
        final email = request['email'];
        if (email == userEmail) {
          final requesterName = request['requesterName'];
          final requesterStdid = request['requesterStdid'];
          final requesterDepartment = request['requesterDepartment'];
          final buttonClicked = int.parse(request['buttonClicked'] ??
              '0'); // Parse buttonClicked as an integer

          bool requestExists = dueRequests
              .any((element) => element.studentNumber == requesterStdid);

          if (buttonClicked == 0 && !requestExists) {
            // Check buttonClicked and if the request doesn't exist
            DueRequest dueRequest = DueRequest(
              name: requesterName,
              studentName: requesterName,
              studentNumber: requesterStdid,
              studentDepartment: requesterDepartment,
              status: "Pending",
              message: "",
              buttonClicked: buttonClicked,
            );
            updatedRequests.add(dueRequest);
          }
        }
      }

      if (updatedRequests.isNotEmpty) {
        setState(() {
          dueRequests.addAll(updatedRequests);
          saveData();
        });
      }
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        title: Text(
          'Requests',
          style: GoogleFonts.inter(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: DepartmentStatusList(
        addDueRequest: addDueRequest,
        dueRequests: dueRequests,
      ),
    );
  }
}

class DepartmentStatusList extends StatelessWidget {
  final Function(DueRequest) addDueRequest;
  final List<DueRequest> dueRequests;

  const DepartmentStatusList({
    required this.addDueRequest,
    required this.dueRequests,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   if (dueRequests.isEmpty) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.hourglass_empty, // You can choose an appropriate icon
          size: 48,
          color: Color.fromARGB(255, 255, 255, 255), // Customize the color as needed
        ),
        SizedBox(height: 10),
        Text(
          'No requests to display',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255), // Customize the color as needed
          ),
        ),
      ],
    ),
  );
    } else {
      return ListView.builder(
        itemCount: dueRequests.length,
        itemBuilder: (context, index) {
          final dueRequest = dueRequests[index];
          return DepartmentStatusTile(
            departmentStatus: DepartmentStatus(
              individualStatus: IndividualStatus(
                name: dueRequest.studentName,
                studentName: dueRequest.studentName,
                studentNumber: dueRequest.studentNumber,
                studentDepartment: dueRequest.studentDepartment,
              ),
            ),
            addDueRequest: addDueRequest,
          );
        },
      );
    }
  }
}


class DepartmentStatus {
  DepartmentStatus({
    required this.individualStatus,
  });

  final IndividualStatus individualStatus;
}

class IndividualStatus {
  IndividualStatus({
    required this.name,
    required this.studentName,
    required this.studentNumber,
    required this.studentDepartment,
  });

  final String name;
  final String studentName;
  final String studentNumber;
  final String studentDepartment;
}

class DepartmentStatusTile extends StatefulWidget {
  final Function(DueRequest) addDueRequest;

  const DepartmentStatusTile({
    required this.addDueRequest,
    Key? key,
    required this.departmentStatus,
  }) : super(key: key);

  final DepartmentStatus departmentStatus;
  

  @override
  _DepartmentStatusTileState createState() => _DepartmentStatusTileState();
}

class DueRequest {
  final String name;
  final String studentName;
  final String studentNumber;
  final String studentDepartment;
  String status;
  final String message;
  int buttonClicked;
  bool isAccepted; // Add this field
  bool isRejected; // Add this field

  DueRequest({
    required this.name,
    required this.studentName,
    required this.studentNumber,
    required this.studentDepartment,
    required this.status,
    required this.message,
    this.isAccepted = false,
    this.isRejected = false,
    this.buttonClicked = 0,
  });

  factory DueRequest.fromJson(Map<String, dynamic> json) {
    return DueRequest(
      name: json['name'],
      studentName: json['studentName'],
      studentNumber: json['studentNumber'],
      studentDepartment: json['studentDepartment'],
      status: json['status'],
      message: json['message'],
      isAccepted: json['isAccepted'] ?? false,
      isRejected: json['isRejected'] ?? false,
      buttonClicked: int.parse(json['buttonClicked'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentName': studentName,
      'studentNumber': studentNumber,
      'studentDepartment': studentDepartment,
      'status': status,
      'message': message,
      'buttonClicked': buttonClicked,
      'isAccepted': isAccepted,
      'isRejected': isRejected,
    };
  }
}

class _DepartmentStatusTileState extends State<DepartmentStatusTile> {
  bool isExpanded = false;
  bool isAccepted = false;
  bool isRejected = false;
  String statusMessage = '';
  int buttonClicked = 0;

  Future<void> showConfirmationDialog() async {
    if (isAccepted || isRejected) {
      // Display a message if it's already accepted or rejected
      setState(() {
        statusMessage = 'Already Verified';
      });
    } else {
      final result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content:
                const Text("Do you want to accept or reject this request?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop("Cancel");
                },
              ),
              TextButton(
                child: const Text("Accept"),
                onPressed: () {
                  Navigator.of(context).pop("Accept");
                },
              ),
              TextButton(
                child: const Text("Reject"),
                onPressed: () {
                  Navigator.of(context).pop("Reject");
                },
              ),
            ],
          );
        },
      );

      if (result == "Accept") {
        setState(() {
          isAccepted = true;
          isRejected = false;
          updateRequestStatus(
              widget.departmentStatus.individualStatus.studentNumber,
              'accepted');
          statusMessage = 'Accepted';
          isExpanded = false; // Hide the entire widget after 1 second
        });
        // Hide the widget after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isExpanded = false;
          });
        });
      } else if (result == "Reject") {
        setState(() {
          isAccepted = false;
          isRejected = true;
          updateRequestStatus(
              widget.departmentStatus.individualStatus.studentNumber,
              'rejected');
          statusMessage = 'Rejected';
          isExpanded = false; // Hide the entire widget after 1 second
        });
        // Hide the widget after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isExpanded = false;
          });
        });
      }
    }
  }

  Future<void> updateRequestStatus(
      String studentNumber, String newStatus) async {
    const apiUrl =
        'http://10.0.2.2/eclearanceAPI/update_request_status.php'; // Replace with the actual API URL
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> requestData = {
      'studentNumber': studentNumber,
      'status': newStatus,
      'buttonClicked': 1, // Set buttonClicked to 1 when status is updated
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Update the status of the request here if needed
      } else {
        throw Exception('Failed to update the request status.');
      }
    } catch (e) {
      throw Exception('Failed to update the request status.');
    }
  }

  TextEditingController inputController = TextEditingController();

  Future<void> showInputDialog() async {
    String studentNumber =
        widget.departmentStatus.individualStatus.studentNumber;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ask Due"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: inputController,
                maxLines: 5, // Allow multiple lines
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Ask"),
              onPressed: () async {
                // Handle the "Ask Due" action with the input text here
                String dueMessage = inputController.text;

                // Send the message to the "buttonclicked.php" API
                sendDueMessageToAPI(studentNumber, dueMessage);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendDueMessageToAPI(String studentNumber, String message) async {
    const apiUrl =
        'http://10.0.2.2/eclearanceAPI/buttonclicked.php'; // Replace with the actual API URL
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail');

    final Map<String, dynamic> requestData = {
      'requesterStdid': studentNumber,
      'DueMessage': message,
      'email': userEmail,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print("Request sent");
      } else {
        throw Exception('Failed to send the request.');
      }
    } catch (e) {
      throw Exception('Failed to send the request.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Name: ${widget.departmentStatus.individualStatus.studentName}',
                ),
                Text(
                  'Student No: ${widget.departmentStatus.individualStatus.studentNumber}',
                ),
                Text(
                    widget.departmentStatus.individualStatus.studentDepartment),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (buttonClicked ==
                      0) // Display buttons if buttonClicked is 0
                    if (isAccepted)
                      const Text(
                        'Status: Accepted',
                        style: TextStyle(color: Colors.green),
                      ),
                  if (isRejected)
                    const Text(
                      'Status: Rejected',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (!isAccepted && !isRejected)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        showConfirmationDialog();
                      },
                      child: const Text('Accept/Reject',
                          style: TextStyle(color: Colors.white)),
                    ),
                  if (!isAccepted && !isRejected)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        showInputDialog();
                      },
                      child: const Text('Ask Due',
                          style: TextStyle(color: Colors.white)),
                    ),
                  if (buttonClicked ==
                      1) // Display status without buttons if buttonClicked is 1
                    Text(
                      'Status: $statusMessage',
                      style: TextStyle(
                        color: isAccepted
                            ? Colors.green
                            : isRejected
                                ? Colors.red
                                : Colors.black,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
