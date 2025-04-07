import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  static Future<Position?> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Location services are disabled.");
      _showLocationDialog(context); // Show dialog to enable GPS
      return null;
    }

    // ✅ Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Location permission denied by user.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌ Location permission permanently denied.");
      _showLocationDialog(context); // Ask user to enable manually
      return null;
    }

    // ✅ Fetch location
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return position;
    } catch (e) {
      print("❌ Error getting location: $e");
      return null;
    }
  }

  // ✅ Show dialog to enable location
  static void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enable Location"),
        content: Text("Please turn on location services to use this feature."),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },
            child: Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
