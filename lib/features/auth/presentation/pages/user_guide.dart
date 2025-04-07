import 'package:flutter/material.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Guide"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle("🔰 Getting Started"),
          _buildSectionText(
              "1. Sign up or log in to the app using your email and password.\n"
              "2. After login, you'll be taken to the Home Page."),
          _buildSectionTitle("👭 Add Emergency Contacts"),
          _buildSectionText(
              "1. Go to the SOS page  > Manage Emergency Contacts.\n"
              "2. Tap 'Add Friend from Contacts' to add up to 5 friends.\n"
              "3. They will be notified when you trigger SOS."),
          _buildSectionTitle("🚨 Using SOS Button"),
          _buildSectionText(
              "1. Tap the SOS button from the bottom navigation.\n"
              "2. Ensure SMS permissions are enabled."),
          _buildSectionTitle("⚙️ App Settings"),
          _buildSectionText("1. Edit profile\n"
              "2. Change password or manage notification settings."),
          _buildSectionTitle("📍 Enable Location"),
          _buildSectionText(
              "1. Location is used to help friends find you in an emergency.\n"
              "2. Allow location permission when prompted."),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Thank you for using our app! Stay safe ❤️",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
