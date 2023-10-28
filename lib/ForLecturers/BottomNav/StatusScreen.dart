import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a54d5),
      appBar: AppBar(
        backgroundColor: const Color(0xff2a54d5),
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
      body: DepartmentStatusList(),
    );
  }
}

class DepartmentStatusList extends StatelessWidget {
  final List<DepartmentStatus> departmentStatusList = [
    DepartmentStatus(
      department: 'Department of Civil Engineering',
      individualStatus: [
        IndividualStatus(name: 'Survey Lab', status: 'Accepted'),
        IndividualStatus(name: 'Concrete & Mtl. Testing Lab', status: 'Rejected'),
        IndividualStatus(name: 'PHE Lab', status: 'Pending'),
        IndividualStatus(name: 'Hydraulics Lab', status: 'Accepted'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Architecture',
      individualStatus: [
        IndividualStatus(name: 'Carpentry Workshop', status: 'Accepted'),
        IndividualStatus(name: 'Head of Department', status: 'Rejected'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Electrical Engineering',
      individualStatus: [
        IndividualStatus(name: 'Electronics Laboratory', status: 'Pending'),
        IndividualStatus(name: 'Instrumentation Laboratory', status: 'Accepted'),
        IndividualStatus(name: 'Electrical Machine Laboratory', status: 'Accepted'),
        IndividualStatus(name: 'Control Systems Laboratory', status: 'Rejected'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Electronics and Communication',
      individualStatus: [
        IndividualStatus(name: 'Digital Electronics Laboratory', status: 'Rejected'),
        IndividualStatus(name: 'Communication Laboratory', status: 'Accepted'),
        IndividualStatus(name: 'Microwave Engineering Laboratory', status: 'Pending'),
        IndividualStatus(name: 'VLSI and DSP Laboratory', status: 'Accepted'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Humanities & Science',
      individualStatus: [
        IndividualStatus(name: 'Physics Laboratory', status: 'Rejected'),
        IndividualStatus(name: 'Chemistry Laboratory', status: 'Accepted'),
        IndividualStatus(name: 'Engg. Mech Lab', status: 'Pending'),
        IndividualStatus(name: 'Head of Department', status: 'Accepted'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Department of Information Technology',
      individualStatus: [
        IndividualStatus(name: 'Overall Lab. In-charge', status: 'Accepted'),
        IndividualStatus(name: 'Head of Department', status: 'Pending'),
        // Add more individual statuses here
      ],
    ),
    DepartmentStatus(
      department: 'Administration & Finance',
      individualStatus: [
        IndividualStatus(name: 'Library', status: 'Accepted'),
        IndividualStatus(name: 'IT Services', status: 'Rejected'),
        IndividualStatus(name: 'Central Store', status: 'Pending'),
        IndividualStatus(name: 'Electrical Maintenance Unit', status: 'Accepted'),
        IndividualStatus(name: 'Estate', status: 'Rejected'),
        IndividualStatus(name: 'Carpentry', status: 'Pending'),
        IndividualStatus(name: 'Fablab CST', status: 'Accepted'),
        IndividualStatus(name: 'Hostel', status: 'Rejected'),
        IndividualStatus(name: 'Admin/Establishment', status: 'Pending'),
        IndividualStatus(name: 'Finance Officer', status: 'Accepted'),
        IndividualStatus(name: 'College Canteen', status: 'Rejected'),
        IndividualStatus(name: 'Cooperative Store', status: 'Pending'),
        // Add more individual statuses here
      ],
    ),
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
  final String department;
  String status;
  final List<IndividualStatus> individualStatus;

  DepartmentStatus({
  required this.department,
  this.status = 'Pending', // Provide a default value
  required this.individualStatus,
  });
}

class IndividualStatus {
  final String name;
  String status;

  IndividualStatus({required this.name, required this.status});
}

class DepartmentStatusTile extends StatefulWidget {
  final DepartmentStatus departmentStatus;

  DepartmentStatusTile({Key? key, required this.departmentStatus})
      : super(key: key);

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
                  .map((individualStatus) {
                Icon statusIcon;
                Color statusColor;

                if (individualStatus.status == 'Accepted') {
                  statusIcon = const Icon(Icons.check, color: Colors.green);
                  statusColor = Colors.green;
                } else if (individualStatus.status == 'Rejected') {
                  statusIcon = const Icon(Icons.close, color: Colors.red);
                  statusColor = Colors.red;
                } else {
                  statusIcon = const Icon(Icons.remove, color: Colors.orange);
                  statusColor = Colors.orange;
                }

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(individualStatus.name),
                      statusIcon,
                    ],
                  ),
                  subtitle: Text(
                    individualStatus.status,
                    style: TextStyle(color: statusColor),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
