import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreenLec extends StatefulWidget {
  const MainScreenLec({Key? key}) : super(key: key);

  @override
  _MainScreenLecState createState() => _MainScreenLecState();
}

class _MainScreenLecState extends State<MainScreenLec> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a54d5),
      appBar: AppBar(
        backgroundColor: const Color(0xff2a54d5),
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
      body: DepartmentStatusList(),
    );
  }
}

class DepartmentStatusList extends StatelessWidget {
  // Add more department statuses here

  DepartmentStatusList({Key? key});

  final List<DepartmentStatus> departmentStatusList = [
    DepartmentStatus(
      individualStatus: IndividualStatus(
        name: 'Survey Lab',
        studentName: 'Tashi K',
        studentNumber: '02210230',
        studentDepartment: 'Information Technology',
      ),
    ),
    // Add more departments and individual statuses here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: departmentStatusList.length,
      itemBuilder: (context, index) {
        final departmentStatus = departmentStatusList[index];
        return DepartmentStatusTile(departmentStatus: departmentStatus);
      },
    );
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
  var status;
}

class DepartmentStatusTile extends StatefulWidget {
  DepartmentStatusTile({Key? key, required this.departmentStatus})
      : super(key: key);

  final DepartmentStatus departmentStatus;

  @override
  _DepartmentStatusTileState createState() => _DepartmentStatusTileState();
}

class _DepartmentStatusTileState extends State<DepartmentStatusTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student Name: ${widget.departmentStatus.individualStatus.studentName}',
                ),
                Text('Student No: ${widget.departmentStatus.individualStatus.studentNumber}'),
                Text(widget.departmentStatus.individualStatus.studentDepartment),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 133, 168, 134), // Green color for Accept
                    ),
                    onPressed: () {
                      // Handle the accept action here
                    },
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Red color for Reject
                    ),
                    onPressed: () {
                      // Handle the reject action here
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Orange color for Ask Due
                    ),
                    onPressed: () {
                      // Handle the ask due action here
                    },
                    child: const Text('Ask Due', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
