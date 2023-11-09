// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 65,
        backgroundColor: const Color(0xFFB0B3BF),
      ),
      backgroundColor: const Color(0xff2a54d5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRoundedTextField('Old Password', true, oldPasswordController),
            const SizedBox(height: 20),
            _buildRoundedTextField('New Password', true, newPasswordController),
            const SizedBox(height: 20),
            _buildRoundedTextField(
                'Confirm New Password', true, confirmNewPasswordController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your password change logic here
                changePassword(context); // Pass the context to show the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A6A8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedTextField(
      String label, bool obscureText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        obscureText: obscureText,
      ),
    );
  }

  Future<void> changePassword(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('userEmail');

    if (storedEmail != null && storedEmail.isNotEmpty) {
      final apiUrl =
          Uri.parse('http://10.0.2.2/eclearanceAPI/eclearanceuserinfo.php');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        List<dynamic> userDataList = jsonDecode(response.body);

        // Search for the user with the specified email
        var userToUpdate = userDataList.firstWhere(
          (userData) => userData['email'] == storedEmail,
          orElse: () => null,
        );

        if (userToUpdate != null) {
          String oldPassword = oldPasswordController.text;
          String newPassword = newPasswordController.text;
          String confirmNewPassword = confirmNewPasswordController.text;

          if (newPassword == confirmNewPassword) {
            final apiUrl2 =
                Uri.parse('http://10.0.2.2/eclearanceAPI/updatepassword.php');
            final updateResponse = await http.post(apiUrl2,
                headers: {
                  'Content-Type':
                      'application/json', // Set the content type to JSON
                },
                body: jsonEncode({
                  'email': storedEmail,
                  'oldPassword': oldPassword,
                  'newPassword': newPassword,
                }));

            if (updateResponse.statusCode == 200) {
              // Password updated successfully, show a dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: const Text('Password updated successfully.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context).pop(); // Navigate back to the
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else if (updateResponse.statusCode == 401) {
              // Handle invalid email or old password
            } else {
              // Handle other errors
            }
          } else {
            // Handle passwords do not match
          }
        } else {
          // Handle user not found
        }
      } else {
        // Handle API request failure
      }
    } else {
      // Handle missing or empty stored email
    }
  }
}
