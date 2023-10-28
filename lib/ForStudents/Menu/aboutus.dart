import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class aboutus extends StatelessWidget {
  const aboutus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 65,
        backgroundColor: const Color(0xFFB0B3BF),
      ),
      body: Container(
        color: const Color(0xff2a54d5),
        child: ListView(
          children: <Widget>[
            Stack(
              children: [
                Image.asset(
                  'Images/basketball_Login.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 200,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20), // Adding padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Adding rounded corners
                ),
                child: Text(
                  'Welcome to our journey! We are a group of college students working on a project, dedicated to providing innovative solutions. Our exciting journey began together, and we are committed to learning and growing.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const AboutUsInfo(label: 'Founded', value: '2023'),
            const AboutUsInfo(label: 'Location', value: 'College Campus, USA'),
            const AboutUsInfo(label: 'Team Size', value: '4'),
            const AboutUsInfo(label: 'Mission', value: 'To learn and innovate together'),
            const AboutUsInfo(label: 'Values', value: 'Collaboration, Creativity, Fun'),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AboutUsInfo extends StatelessWidget {
  final String label;
  final String value;

  const AboutUsInfo({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
