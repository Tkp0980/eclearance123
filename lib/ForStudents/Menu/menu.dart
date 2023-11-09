// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:eclearance/ForStudents/Menu/aboutus.dart';
import 'package:eclearance/ForStudents/Menu/changePass.dart';
import 'package:eclearance/ForStudents/Menu/dues.dart';
import 'package:eclearance/ForStudents/Menu/history.dart';
import 'package:eclearance/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
   // Define a variable to store the student ID

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
        final data = json.decode(response.body);
        setState(() {
          userData = data;
          isLoading = false;
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

  Future<void> handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('studentId'); // Remove student ID when logging out
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  Future<void> navigateToDuesPage() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const DuesDetailPage()));
  }

  Future<void> navigateToHistoryPage() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HistoryPage()));
  }

  Future<void> navigateToAboutUsPage() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const aboutus()));

  }
  Future<void> navigateTopassword() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) =>  ChangePassword()));
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
      backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Profile Section
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
                              'Student No: ${userData['StudentID'] ?? ''}',
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
                        ListTile(
                          leading: Icon(Icons.money, color: iconColor),
                          title: Text(
                            'Dues',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          onTap: navigateToDuesPage,
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.history, color: iconColor),
                          title: Text(
                            'History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          onTap: navigateToHistoryPage,
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
                          onTap: navigateTopassword,
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
                          onTap: navigateToAboutUsPage,
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
                          onTap: handleLogout,
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
