import 'package:flutter/material.dart';
import 'package:women/core/theme/app_pallete.dart';
import 'package:women/features/auth/presentation/pages/sos_page.dart';
import 'safe_mate_drawer.dart';
import 'home_page.dart';
import 'location_page.dart';
import 'safety_tips.dart';
import 'help_page.dart';

class BasePage extends StatefulWidget {
  final Widget body;
  final int selectedIndex;

  BasePage({required this.body, required this.selectedIndex});

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  void _onItemTapped(int index) {
    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = HomePage();
        break;
      case 1:
        nextPage = LocationPage();
        break;
      case 2:
        nextPage = SOSPage();
        break;
      case 3:
        nextPage = SafetyGuidePage();
        break;
      case 4:
        nextPage = HelpPage();
        break;
      default:
        nextPage = HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/tapp_icon.png',
              height: 60, // Adjust logo size
            ),
            SizedBox(width: 8),
            Text(
              "SafeMate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppPallete.backgroundColor,
      ),
      drawer: SafeMateDrawer(),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Keeps all items visible
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: "Location"),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // Solid red background
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 169, 63, 55),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(Icons.sos, color: Colors.white, size: 32),
            ),
            label: "SOS",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.security), label: "Safety Tips"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
