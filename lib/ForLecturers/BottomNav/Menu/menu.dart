// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:eclearance/ForLecturers/BottomNav/Menu/changepass.dart';
import 'package:eclearance/ForStudents/Menu/aboutus.dart';
import 'package:eclearance/ForLecturers/BottomNav/Menu/history.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

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
        try {
          final data = json.decode(response.body);
          setState(() {
            userData = data;
            isLoading = false;
          });
          // ignore: empty_catches
        } catch (e) {}
      } else {}
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB0B3BF),
        toolbarHeight: 65,
      ),
      backgroundColor: const Color(0xff2a54d5),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['FirstName'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              userData['email'] ?? '',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Role: ${userData['roleName'] ?? ''}',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Department: ${userData['DepartmentName'] ?? ''}',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.history,
                              color: iconColor), // History icon
                          title: Text(
                            'History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HistoryPage(), // Navigate to History page
                              ),
                            );
                          },
                        ),
                          const SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.lock,
                              color: iconColor), // Icon for Change Password
                          title: Text(
                            'Change Password', // Change Password menu item
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                       onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangePassword(), // Navigate to ChangePassword widget
      ),
    );
  }
),
                        const SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.info, color: iconColor),
                          title: Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const aboutus(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.exit_to_app, color: iconColor),
                          title: Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          onTap: () {
                            handleLogout();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
