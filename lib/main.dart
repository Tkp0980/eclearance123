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
    return  MaterialApp(
       theme: ThemeData.light(), // Set the light theme as the default
      darkTheme: ThemeData.dark(), // Define a dark theme
      themeMode: ThemeMode.system, // Allow the system settings to control the theme
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
  void toggleDarkMode(bool isDarkMode) {
    // Update the state of dark mode here
    // You can use setState or a state management solution
    // to update the theme across the app.
  }

}

class RequestScreen extends StatelessWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a54d5),
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DisplayScreen ()),
                );
              },
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
                'Request Form',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
