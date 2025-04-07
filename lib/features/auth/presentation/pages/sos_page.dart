import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women/database/database_helper.dart';
import 'package:women/core/theme/app_pallete.dart';
import 'package:women/features/auth/presentation/pages/location_service.dart';
import 'home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSPage extends StatefulWidget {
  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  static const platform = MethodChannel('sendSms');
  List<Map<String, dynamic>> friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final friendList = await DatabaseHelper.instance.getAllFriends();
    setState(() {
      friends = friendList;
    });
  }

  Future<void> sendEmergencySMS({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      final String result = await platform.invokeMethod('sendSMS', {
        "phoneNumber": phoneNumber,
        "message": message,
      });
      print("✅ Sent to $phoneNumber: $result");
    } catch (e) {
      print("❌ Failed to send SMS to $phoneNumber: $e");
    }
  }

  Future<void> requestSMSPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      var result = await Permission.sms.request();
      if (!result.isGranted) {
        // ⚠️ Early return if permission not granted
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ SMS Permission Denied")),
        );
        return;
      }
    }
  }

  Future<String> _getCustomMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sos_message') ??
        "🚨 SOS Alert! I need help!"; // default message
  }

  Future<void> sendToAll() async {
    await requestSMSPermission();

    if (friends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ No friends to send SOS.")),
      );
      return;
    }

    final position = await LocationService.getCurrentLocation(context);
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to get your location.")),
      );
      return;
    }

    final customMessage = await _getCustomMessage();
    final message =
        "$customMessage\n📍 Location: https://maps.google.com/?q=${position.latitude},${position.longitude}";

    for (final friend in friends) {
      await sendEmergencySMS(
        phoneNumber: friend['phone'],
        message: message,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ SOS sent to all your friends!")),
    );
  }

  Future<void> _deleteFriend(int id) async {
    await DatabaseHelper.instance.deleteFriend(id);
    await _loadFriends();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🗑️ Friend deleted")),
    );
  }

  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Friend"),
        content: Text("Are you sure you want to delete $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFriend(id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 190, 190),
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text("SOS Alert"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Friends who will receive SOS:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Expanded(
            child: friends.isEmpty
                ? Center(
                    child: Text(
                      "📭 No friends added yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  )
                : ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.person, color: Colors.black87),
                          title: Text(friend['name']),
                          subtitle: Text(friend['phone']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(
                              context,
                              friend['id'],
                              friend['name'],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton.icon(
              onPressed: sendToAll,
              icon: Icon(Icons.warning_amber, color: Colors.white),
              label: Text("Send SOS",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 229, 38, 38),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
