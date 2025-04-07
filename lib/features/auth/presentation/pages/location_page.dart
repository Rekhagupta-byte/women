import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:women/core/theme/app_pallete.dart';
import 'package:women/features/auth/presentation/pages/location_Service.dart';
import 'package:geocoding/geocoding.dart'; // ✅ Added for location search
import 'base_page.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController =
      TextEditingController(); // ✅ Search input

  LatLng _initialPosition = LatLng(19.0760, 72.8777); // ✅ Default: Mumbai
  LatLng? _searchedLocation; // ✅ Store searched location
  bool isLoading = true; // ✅ For smooth animation

  @override
  void initState() {
    super.initState();
    _setUserLocation();
  }

  // ✅ Fetch user's real-time location
  Future<void> _setUserLocation() async {
    print("📍 Fetching user location...");
    final position = await LocationService.getCurrentLocation(context);
    if (position != null && mounted) {
      print("✅ Location received: ${position.latitude}, ${position.longitude}");

      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        isLoading = false; // ✅ Stop loading
      });

      _mapController.move(_initialPosition, 15.0);
    } else {
      print("❌ Location not available.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location is off. Please enable GPS.")),
      );
    }
  }

  // ✅ Search for a location and update the map
  // ✅ Search for a location and update the map
  Future<void> _searchLocation(String query) async {
    try {
      print("🔍 Searching for: $query");
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final searchedLatLng =
            LatLng(locations.first.latitude, locations.first.longitude);
        print(
            "✅ Location found: ${searchedLatLng.latitude}, ${searchedLatLng.longitude}");

        setState(() {
          _searchedLocation = searchedLatLng;
          _searchController.clear(); // ✅ Clear text after searching
        });

        _mapController.move(searchedLatLng, 15.0);
      } else {
        print("❌ Location not found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location not found. Try another search.")),
        );
      }
    } catch (e) {
      print("❌ Error searching location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error searching location. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 1,
      body: Stack(
        children: [
          // ✅ OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPosition,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://a.tile.openstreetmap.de/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  // ✅ User's location marker
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: _initialPosition,
                    child: Icon(Icons.person_pin_circle,
                        color: Colors.blue, size: 50),
                  ),
                  // ✅ Searched location marker (if exists)
                  if (_searchedLocation != null)
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: _searchedLocation!,
                      child: Icon(Icons.location_pin,
                          color: Colors.blue, size: 50),
                    ),
                ],
              ),
            ],
          ),

          // ✅ Search Bar
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                      color: Colors.black), // ✅ Text color set to black
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search for a location...",
                    hintStyle: TextStyle(
                        color: Colors.grey[700]), // ✅ Hint text more visible
                    filled: true,
                    fillColor: Colors.white, // ✅ Ensure background is white
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.black, width: 1.5), // ✅ Black border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: AppPallete.backgroundColor,
                          width: 3), // ✅ Blue border when focused
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  onSubmitted: (value) => _searchLocation(value),
                )),
          ),

          // ✅ Floating Action Buttons
          Positioned(
            bottom: 80,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "center",
                  onPressed: () {
                    _mapController.move(_initialPosition, 15.0);
                  },
                  child: Icon(Icons.gps_fixed),
                  backgroundColor: Colors.blue,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: () {
                    _mapController.move(
                        _initialPosition, _mapController.camera.zoom + 1);
                  },
                  child: Icon(Icons.zoom_in),
                  backgroundColor: Colors.green,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: () {
                    _mapController.move(
                        _initialPosition, _mapController.camera.zoom - 1);
                  },
                  child: Icon(Icons.zoom_out),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ),

          // ✅ Smooth Animated Loader
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
