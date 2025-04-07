import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women/core/theme/app_pallete.dart';
import 'package:women/features/auth/presentation/pages/home_page.dart';
import 'package:women/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _imageFile;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // ✅ Fetch user info from Supabase user_metadata
  void _fetchUserInfo() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final userMetadata = user.userMetadata;
      _nameController.text = userMetadata?['name'] ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  // ✅ Update user name in Supabase metadata
  Future<void> _updateProfile() async {
    try {
      await supabase.auth.updateUser(UserAttributes(
        data: {
          'name': _nameController.text.trim(),
        },
      ));
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Profile updated successfully!')),
      );
    } catch (e) {
      print('❌ Update error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  // ✅ Pick image from gallery
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Profile Picture
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                backgroundColor: Colors.white,
                child: _imageFile == null
                    ? Icon(Icons.person,
                        size: 50, color: AppPallete.backgroundColor)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // ✅ Name Field
            TextField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),

            // ✅ Email Field (Always disabled)
            TextField(
              controller: _emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            Divider(),

            // ✅ Edit/Save Button
            ElevatedButton(
              onPressed: () {
                if (_isEditing) {
                  _updateProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
            ),

            // ✅ Logout
            TextButton.icon(
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text("Logout", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await supabase.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
