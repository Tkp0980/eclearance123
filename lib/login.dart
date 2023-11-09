import 'package:eclearance/ForLecturers/BottomNav/RequestScreen.dart';
import 'package:eclearance/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key, Key? key1});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;

  Future<Map<String, dynamic>> fetchUserData(String email) async {
    const apiUrl = 'http://10.0.2.2/eclearanceAPI/get_user_data.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {};
    }
  }

  Future<void> showAlertDialog(String title, String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    const apiUrl = 'http://10.0.2.2/eclearanceAPI/login.php';

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseText = response.body;
        final startIndex = responseText.indexOf('{');

        if (startIndex != -1) {
          final jsonResponse = json.decode(responseText.substring(startIndex));
          String message = jsonResponse['message'];

          if (message == "Authenticated") {
            await saveUserEmail(email);
            await Future.delayed(const Duration(seconds: 1));
            final userData = await fetchUserData(email);

            // ignore: unnecessary_null_comparison
            if (userData != null) {
              navigateToScreen(userData, email);
            } else {
              showAlertDialog("Error", "Failed to fetch user data");
            }
          } else {
            showAlertDialog("Error", "Incorrect login credentials");
          }
        }
      }
    } catch (e) {
      showAlertDialog("Error", "An error occurred during the login process");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }
Future<void> navigateToScreen(
    Map<String, dynamic> userData, String email) async {
  if (email == '02210230.cst@rub.edu.bt') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestScreen(userData: userData),
      ),
    );
  } else if (email == 'SignOne.cst@rub.edu.bt') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayScreenLec(userData: userData),
      ),
    );
  } else {
    // Clear saved data when the user logs out
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dueRequests');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.elliptical(700, 590),
                      bottomRight: Radius.elliptical(700, 590),
                    ),
                    image: DecorationImage(
                      image: const AssetImage('Images/basketball_Login.jpeg'),
                      fit: BoxFit.fitWidth,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor.withOpacity(0.4),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF0028A8),
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset('Images/email.svg'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: passwordController,
                          obscureText: isPasswordHidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset('Images/password.svg'),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  isPasswordHidden
                                      ? 'Images/password_hide.svg'
                                      : 'Images/password_show.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          handleLogin();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Or',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Add your sign-up with Google action here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'Images/google_logo.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Sign Up with Google',
                              style: TextStyle(
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
