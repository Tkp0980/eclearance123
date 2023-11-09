import 'package:flutter/material.dart';
import 'package:eclearance/ForStudents/Menu/menu.dart';
import 'package:eclearance/ForStudents/MessagesInfo.dart';
import 'package:eclearance/ForStudents/StatusScreen.dart';
import 'package:eclearance/ForStudents/lib/mainPage/mainscreen.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  int _currentIndex = 1;
  final ThemeData _darkTheme = ThemeData.dark();
  bool _isDarkMode = false;
  final ThemeData _lightTheme = ThemeData.light();
  late PageController _pageController;
  final List<Widget> _pages = [
    const MessagesInfo(),
    const MainScreen(),
    const StatusScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

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
              icon: ClipOval(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
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
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: ClipOval(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
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
              ),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: ClipOval(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
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
              ),
              label: 'Status',
            ),
          ],
          backgroundColor: const Color(0xFFB0B3BF),
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          selectedItemColor: const Color(0xff2a54d5),
        ),
      ),
    );
  }
}
