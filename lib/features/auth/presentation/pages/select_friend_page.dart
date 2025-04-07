import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:women/database/database_helper.dart';

class SelectFriendsPage extends StatefulWidget {
  @override
  _SelectFriendsPageState createState() => _SelectFriendsPageState();
}

class _SelectFriendsPageState extends State<SelectFriendsPage> {
  List<PhoneContact> selectedContacts = [];

  Future<void> _pickContact() async {
    if (selectedContacts.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ You can only select up to 5 contacts.')),
      );
      return;
    }

    final hasPermission = await FlutterContactPicker.hasPermission();
    if (!hasPermission) {
      await FlutterContactPicker.requestPermission();
    }

    try {
      final PhoneContact contact =
          await FlutterContactPicker.pickPhoneContact();

      if (contact.phoneNumber?.number != null &&
          contact.phoneNumber!.number!.isNotEmpty) {
        setState(() {
          selectedContacts.add(contact);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('❌ Selected contact has no valid phone number.')),
        );
      }
    } catch (e) {
      print("❌ Error picking contact: $e");
    }
  }

  Future<void> _saveContacts() async {
    for (final contact in selectedContacts) {
      final String name = contact.fullName ?? "Unknown";
      final String phone = contact.phoneNumber?.number ?? "";

      if (phone.isNotEmpty) {
        await DatabaseHelper.instance.insertFriend(name, phone);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Friends added successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Up to 5 Friends')),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickContact,
            icon: Icon(Icons.contact_phone),
            label: Text("Pick Contact"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedContacts.length,
              itemBuilder: (context, index) {
                final contact = selectedContacts[index];
                return ListTile(
                  title: Text(contact.fullName ?? ""),
                  subtitle: Text(contact.phoneNumber?.number ?? ""),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        selectedContacts.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedContacts.isNotEmpty ? _saveContacts : null,
        label: Text("Save"),
        icon: Icon(Icons.save),
        backgroundColor:
            selectedContacts.isNotEmpty ? Colors.blue : Colors.grey,
      ),
    );
  }
}
