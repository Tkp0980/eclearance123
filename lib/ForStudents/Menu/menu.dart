import 'package:eclearance/ForStudents/Menu/aboutus.dart';
import 'package:eclearance/ForStudents/Menu/dues.dart';
import 'package:eclearance/ForStudents/Menu/history.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  get bold => null;

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
      body: SingleChildScrollView(
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
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                        'Tashi K',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'TashiK@example.com',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Student No: 02210230',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Department: IT',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu Items with spacing
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>  DuesDetailPage()),
                      );
                    },
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>  const HistoryPage()),
                      );
                    },
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
                            builder: (context) =>  aboutus()),
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
