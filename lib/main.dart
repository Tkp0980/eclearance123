// ignore_for_file: library_private_types_in_public_api

import 'package:eclearance/ForStudents/Menu/menu.dart';
import 'package:eclearance/ForStudents/RequestScreen.dart';
import 'package:eclearance/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Set the light theme as the default
      darkTheme: ThemeData.dark(), // Define a dark theme
      themeMode:
          ThemeMode.system, // Allow the system settings to control the theme
      home: const Login(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => const Login(),
        '/menu': (context) => const MenuScreen(),
        // Add more routes as needed
      },
    );
  }

  void toggleDarkMode(bool isDarkMode) {
    // Update the state of dark mode here
    // You can use setState or a state management solution
    // to update the theme across the app.
  }
}

class RequestScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const RequestScreen({super.key, required this.userData});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool isRequesting = false;

  void requestForm() {
    setState(() {
      isRequesting = true;
    });

    // Simulate a delay of 2 seconds before navigating
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DisplayScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 29, 62, 162),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CST E-Clearance',
              style: GoogleFonts.inter(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Efficient, flexible, and adaptable \napproach to getting the "No Due Certificate" \nin CST',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: isRequesting ? null : requestForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A6A8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                isRequesting ? ' Form initializing...' : 'Go',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            if (isRequesting) const SizedBox(height: 20),
            if (isRequesting)
              const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ],
        ),
      ),
    );
  }
}
