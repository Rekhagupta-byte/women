import 'package:flutter/material.dart';
import 'package:women/features/auth/presentation/pages/base_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 2,
      body: Container(
        color: Colors.white, // ✅ Light background
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              "Help & Support",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black, // ✅ Visible text
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "📱 How to Use the App:\n"
              "- Tap the SOS button in emergencies.\n"
              "- Add trusted friends for emergency contacts.\n"
              "- Allow location access to send your real-time location.\n",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              "❓ FAQs:\n"
              "Q: How does the SOS button work?\n"
              "A: It sends a message with your location to all added friends.\n\n"
              "Q: Can I change my emergency contacts?\n"
              "A: Yes, go to the 'SOS' section to edit them.\n\n"
              "Q: What if my location is turned off?\n"
              "A: You'll be asked to enable it when trying to use location features.\n\n"
              "Q: How many friends can I add?\n"
              "A: You can add up to 5 emergency contacts.\n\n"
              "Q: Do my friends need the app to receive SOS messages?\n"
              "A: No, messages are sent as regular SMS, so no app is needed.\n\n"
              "Q: Can I use the app without internet?\n"
              "A: Yes, SOS messages can be sent offline via SMS if permissions are granted.\n\n"
              "Q: Where can I update my profile information?\n"
              "A: Go to the 'Profile' page to edit your name or upload a picture.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              "🛡️ Safety Tips:\n"
              "- Always keep your phone charged.\n"
              "- Inform someone when you're going out alone.\n"
              "- Use this app to stay connected with trusted people.\n",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              "📞 Contact Support:\n"
              "Email: safemateforwomen@gmail.com\n"
              "Phone: +91-8356075332\n",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Text(
              "📦 App Version: 1.0.0",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
