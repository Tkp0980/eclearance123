// ignore_for_file: file_names

import 'package:eclearance/ForLecturers/BottomNav/DueStatusScreen.dart';
import 'package:eclearance/ForLecturers/BottomNav/lib/mainPage/mainscreen.dart';
import 'package:eclearance/ForLecturers/BottomNav/Menu/menu.dart';
import 'package:eclearance/ForStudents/MessagesInfo.dart';
//import 'package:eclearance/BottomNav/MessagesScreen.dart';
import 'package:flutter/material.dart';



class DisplayScreenLec extends StatefulWidget {
  
   final Map<String, dynamic>? userData;

  const DisplayScreenLec({super.key, required this.userData});


  @override
  // ignore: library_private_types_in_public_api
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreenLec> {
  int _currentIndex = 1;
  bool _isDarkMode = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  final List<Widget> _pages = [
    const MessagesInfo(),
    const MainScreenLec(),
    const DueStatusScreen(),
  ];

  final ThemeData _lightTheme = ThemeData.light();
  final ThemeData _darkTheme = ThemeData.dark();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = _isDarkMode ? _darkTheme : _lightTheme;

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFB0B3BF),
          toolbarHeight: 65,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const MenuScreen();
                }));
              },
              iconSize: 32,
            ),
          ),
          actions: <Widget>[
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 29, 62, 162),
        body: PageView(
          controller: _pageController,
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.mail,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.request_page,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              label: 'Status',
            ),
          ],
          backgroundColor: const Color(0xFFB0B3BF),
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          selectedItemColor: const Color.fromARGB(255, 29, 62, 162),
        ),
      ),
    );
  }
}