import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        return DepartmentStatusTile(departmentStatus: departmentStatus);
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
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to make this request?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            // Close the dialog
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Handle the request action here
                                            // Close the dialog
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
}
