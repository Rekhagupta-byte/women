import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: const [
          Text(
            "Privacy Policy",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "1. Information Collection:\n"
            "- We collect your name, email and emergency contact numbers.\n"
            "- We also use your location to send accurate emergency alerts to your contacts.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "2. Usage of Information:\n"
            "- Your data is used only to send SOS messages and help you stay safe.\n"
            "- We do not sell or share your personal data with third parties.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "3. Data Security:\n"
            "- We store your data securely using encrypted databases.\n"
            "- Access is limited only to you.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "4. Permissions:\n"
            "- Location and SMS permissions are required to use SOS features effectively.\n"
            "- These are used only during emergencies.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "5. User Rights:\n"
            "- You can update or delete your data anytime through the profile settings.\n"
            "- You can revoke app permissions from your device settings.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "6. Contact Us:\n"
            "If you have any questions, feel free to contact us at safemateforwomen@gmail.com",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
