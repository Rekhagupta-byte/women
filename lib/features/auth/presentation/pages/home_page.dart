import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:women/core/theme/app_pallete.dart';
import 'package:women/database/database_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women/features/auth/presentation/pages/base.dart';
import 'base_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> selectedContacts = [];

  @override
  void initState() {
    super.initState();
    exportDatabaseOnStartup();
    _loadContacts(); // Only to get the count
  }

  Future<void> exportDatabaseOnStartup() async {
    await requestStoragePermission();
    await DatabaseHelper.instance.exportDatabase();
  }

  Future<void> requestStoragePermission() async {
    await Permission.storage.request();
  }

  Future<void> _loadContacts() async {
    try {
      List<Map<String, dynamic>> contacts =
          await DatabaseHelper.instance.getAllFriends();
      if (mounted) {
        setState(() {
          selectedContacts = contacts
              .map((e) =>
                  {'name': e['name'] as String, 'phone': e['phone'] as String})
              .toList();
        });
      }
    } catch (e) {
      print("❌ Error loading contacts: $e");
    }
  }

  Future<void> _debugPrintContacts() async {
    List<Map<String, dynamic>> contacts =
        await DatabaseHelper.instance.getAllFriends();
    print("📌 Stored Contacts in Database: $contacts");
  }

  Future<void> _pickContact() async {
    try {
      if (!(await Permission.contacts.request().isGranted)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Contacts permission denied.')),
        );
        return;
      }

      List<Map<String, dynamic>> storedContacts =
          await DatabaseHelper.instance.getAllFriends();
      if (storedContacts.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ You can only add up to 5 contacts.')),
        );
        return;
      }

      final PhoneContact contact =
          await FlutterContactPicker.pickPhoneContact();

      final String fullName = contact.fullName ?? "Unknown";
      final String phoneNumber = contact.phoneNumber?.number ?? "";

      if (phoneNumber.isNotEmpty) {
        await DatabaseHelper.instance.insertFriend(fullName, phoneNumber);
        await _debugPrintContacts();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Friend "$fullName" added successfully!')),
        );
        _loadContacts();
      } else {
        print("❌ Contact does not have a valid phone number.");
      }
    } catch (e) {
      print("❌ Error picking contact: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePage(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -50,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/women.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1.1,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your SafeMate is Here!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 186, 156, 235),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Stay safe, be aware, and always have a plan!",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppPallete.whiteColor,
                      shadows: [
                        Shadow(
                            blurRadius: 2.0,
                            color: Colors.black26,
                            offset: Offset(1, 1)),
                      ],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 155,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _pickContact,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppPallete.backgroundColor,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.contacts, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "Add Friend from Contacts",
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: SizedBox(width: 300, height: 100, child: LiveSafe()),
              ),
            ),
          ],
        ),
        selectedIndex: 0,
      ),
    );
  }
}
