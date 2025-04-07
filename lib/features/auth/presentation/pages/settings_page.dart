import 'package:flutter/material.dart';
import 'package:women/features/auth/presentation/pages/change_passward.dart';
import 'package:women/features/auth/presentation/pages/privacy_policy_page.dart';
import 'package:women/features/auth/presentation/pages/profile_page.dart';

import 'package:women/features/auth/presentation/pages/user_guide.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool sosSound = true;
  bool autoLocation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.redAccent, // Adjust color if needed
      ),
      body: ListView(
        children: [
          // 🔹 Profile Settings
          _buildSectionTitle("Profile Settings"),
          _buildListTile(Icons.person, "Edit Profile", onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          }),

          _buildListTile(Icons.lock, "Change Password", onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChangePasswordPage()),
            );
          }),

          // 🔹 Help & Support
          _buildSectionTitle("Help & Support"),
          _buildListTile(Icons.help, "User Guide", onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserGuidePage()),
            );
          }),
          _buildListTile(Icons.privacy_tip, "Privacy Policy", onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
            );
          }),
        ],
      ),
    );
  }

  // 🔹 Helper Methods for UI Elements
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
