import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women/core/theme/app_pallete.dart';
import 'package:women/features/auth/presentation/pages/settings_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'location_page.dart';
import 'safety_tips.dart';
import 'help_page.dart';

class SafeMateDrawer extends StatefulWidget {
  @override
  _SafeMateDrawerState createState() => _SafeMateDrawerState();
}

class _SafeMateDrawerState extends State<SafeMateDrawer> {
  String userName = "Loading...";
  String userEmail = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.userMetadata?['name'] ?? "User";
        userEmail = user.email ?? "No Email";
      });
    } else {
      setState(() {
        userName = "Guest";
        userEmail = "Not Logged In";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // 🔹 Drawer Header with Profile Info
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppPallete.backgroundColor, AppPallete.gradient1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/profile_icon.png'),
                    child: Icon(Icons.person,
                        size: 45, color: AppPallete.backgroundColor),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // 🔹 Drawer Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(context, Icons.home, "Home",
                    () => _navigateTo(context, HomePage())),
                _buildDrawerItem(context, Icons.person, "Profile",
                    () => _navigateTo(context, ProfilePage())),
                _buildDrawerItem(context, Icons.location_on, "Location",
                    () => _navigateTo(context, LocationPage())),
                _buildDrawerItem(context, Icons.security, "Safety Tips",
                    () => _navigateTo(context, SafetyGuidePage())),
                _buildDrawerItem(context, Icons.help, "In-App Support",
                    () => _navigateTo(context, HelpPage())),
              ],
            ),
          ),

          // 🔹 Logout & Settings Section at Bottom
          Divider(),
          _buildDrawerItem(context, Icons.settings, "Settings", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }),

          _buildDrawerItem(context, Icons.exit_to_app, "Logout", () {
            Navigator.pop(context); // Close the drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }),

          SizedBox(height: 15),
        ],
      ),
    );
  }

  // 🔹 Helper Method to Create Drawer Items
  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: AppPallete.gradient1),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.grey.shade200,
        hoverColor: Colors.red.shade100,
        onTap: onTap,
      ),
    );
  }

  // 🔹 Navigation Helper
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
