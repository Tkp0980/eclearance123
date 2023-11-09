// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  String studentId = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');

      if (userEmail == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final apiUrl = Uri.parse(
          'http://10.0.2.2/eclearanceAPI/get_student_info.php?email=$userEmail');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data;
          isLoading = false;
          studentId = userData['StudentID']; // Store the student ID
          prefs.setString('studentId', studentId);
          print(studentId);
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 62, 162),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 62, 162),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DepartmentStatusList(userData: userData),
    );
  }
}

class DepartmentStatusList extends StatelessWidget {
  final Map<String, dynamic> userData;

  DepartmentStatusList({Key? key, required this.userData}) : super(key: key);

  final List<DepartmentStatus> departmentStatusList = [
    DepartmentStatus(
      department: 'Department of Civil Engineering',
      individualStatus: [
        IndividualStatus(name: 'Survey Lab'),
        IndividualStatus(name: 'Concrete & Mtl. Testing Lab'),
        IndividualStatus(name: 'PHE Lab'),
        IndividualStatus(name: 'Hydraulics Lab'),
        IndividualStatus(name: 'Highway Lab'),
        IndividualStatus(name: 'Soil Mechanics Lab'),
        IndividualStatus(name: 'Geology & PRS Lab'),
        IndividualStatus(name: 'Learning Resource Centre'),
        IndividualStatus(name: 'Head of Department'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Architecture',
      individualStatus: [
        IndividualStatus(name: 'Carpentry Workshop'),
        IndividualStatus(name: 'Head of Department'),
      ],
    ),
    DepartmentStatus(
      department: 'Department of Electrical Engineering',
      individualStatus: [
        IndividualStatus(name: 'Electronics Laboratory'),
        IndividualStatus(name: 'Instrumentation Laboratory'),
        IndividualStatus(name: 'Electrical Machine Laboratory'),
        IndividualStatus(name: 'Control Systems Laboratory'),
        IndividualStatus(name: 'Power System laboratory'),
        IndividualStatus(name: 'Electrical Workshop'),
        IndividualStatus(name: 'Head of Department'),
      ],
    ),
    DepartmentStatus(
      department: 'Department of Electronics and Communication',
      individualStatus: [
        IndividualStatus(name: 'Digital Electronics Laboratory'),
        IndividualStatus(name: 'Communication Laboratory'),
        IndividualStatus(name: 'Microwave Engineering Laboratory'),
        IndividualStatus(name: 'VLSI and DSP Laboratory'),
        IndividualStatus(name: 'Electronics Circuits Laboratory'),
        IndividualStatus(name: 'Process Control and PLC Laboratory'),
        IndividualStatus(name: 'Robotic Lab'),
        IndividualStatus(name: 'Head of Department'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Humanities & Science',
      individualStatus: [
        IndividualStatus(name: 'Physics Laboratory'),
        IndividualStatus(name: 'Chemistry Laboratory'),
        IndividualStatus(name: 'Engg. Mech Lab'),
        IndividualStatus(name: 'Head of Department'),
      ],
    ),
    DepartmentStatus(
      department: 'Department of Information Technology',
      individualStatus: [
        IndividualStatus(name: 'Overall Lab. In-charge'),
        IndividualStatus(name: 'Head of Department'),
      ],
    ),
    DepartmentStatus(
      department: 'Administration & Finance',
      individualStatus: [
        IndividualStatus(name: 'Library'),
        IndividualStatus(name: 'IT Services'),
        IndividualStatus(name: 'Central Store'),
        IndividualStatus(name: 'Electrical Maintenance Unit'),
        IndividualStatus(name: 'Estate'),
        IndividualStatus(name: 'Carpentry'),
        IndividualStatus(name: 'Fablab CST'),
        IndividualStatus(name: 'Hostel'),
        IndividualStatus(name: 'Admin/Establishment'),
        IndividualStatus(name: 'Finance Officer'),
        IndividualStatus(name: 'College Canteen'),
        IndividualStatus(name: 'Cooperative Store'),
        // Add more individual statuses here
      ],
    ),

    // Add more department statuses here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: departmentStatusList.length,
      itemBuilder: (context, index) {
        final departmentStatus = departmentStatusList[index];
        return DepartmentStatusTile(
          departmentStatus: departmentStatus,
          userData: userData,
        );
      },
    );
  }
}

class DepartmentStatus {
  DepartmentStatus({
    required this.department,
    required this.individualStatus,
  });

  final String department;
  final List<IndividualStatus> individualStatus;
}

class IndividualStatus {
  IndividualStatus({required this.name});

  final String name;
}

class DepartmentStatusTile extends StatefulWidget {
  const DepartmentStatusTile({
    Key? key,
    required this.departmentStatus,
    required this.userData,
  }) : super(key: key);

  final DepartmentStatus departmentStatus;
  final Map<String, dynamic> userData;

  @override
  _DepartmentStatusTileState createState() => _DepartmentStatusTileState();
}

class _DepartmentStatusTileState extends State<DepartmentStatusTile> {
  bool isExpanded = false;
  bool isRequested = false;
  @override
  void initState() {
    super.initState();
    checkIsRequested(); // Check the request status when the widget is initialized
  }

  Future<void> checkIsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'requestStatus_${widget.departmentStatus.department}';
    final requested = prefs.getBool(key) ?? false;

    setState(() {
      isRequested = requested;
    });
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
            title: Text(
              widget.departmentStatus.department,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
            Column(
              children: widget.departmentStatus.individualStatus
                  .map((individualStatus) => ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(individualStatus.name),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A6A8),
                              ),
                              onPressed: () {
                                showDialog(
                                  context:
                                      context, // This is the correct way to access the context
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to make this request?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            makeRequest(
                                              individualStatus.name,
                                              widget.userData,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Request',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  void saveRequestStatusToSharedPreferences(
      String individualStatusName, bool requested) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'requestStatus_$individualStatusName';

      // Save the request status to shared preferences
      prefs.setBool(key, requested);
    } catch (e) {
      // Handle error if necessary
    }
  }

  Future<void> saveRequestStatus(bool requested) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'requestStatus_${widget.departmentStatus.department}';
    prefs.setBool(key, requested);

    setState(() {
      isRequested = requested;
    });
  }

  void makeRequest(
      String individualStatusName, Map<String, dynamic> userData) async {
    final apiUrl = Uri.parse('http://10.0.2.2/eclearanceAPI/request.php');

    // Create a Map for the request body
    Map<String, dynamic> requestBody = {
      'individualStatusName': individualStatusName,
      'userData': userData,
    };

    // Convert the request body to a JSON string
    String requestBodyJson = json.encode(requestBody);

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      }, // Set the content type to JSON
      body: requestBodyJson,
    );

    if (response.statusCode == 200) {
      // Change the button label to "Requested"
      setState(() {
        isRequested = true;
      });

      saveRequestStatusToSharedPreferences(individualStatusName, true);

      print("Request sent successfully");
    } else {
      // Display an error message
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Request Error'),
              content: const Text('Request already Made'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }
}
