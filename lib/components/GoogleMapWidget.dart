import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _mapController;
  final String _mapStyle = ''; // Add map style if required
  double userLongitude = 0.0;
  double userLatitude = 0.0;
  late LatLng _center;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    GetUserAddress();
  }

  Future<void> GetUserAddress() async {
    try {
      // Get the current user's email
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      String fireEmail = currentUser.email ?? '';
      print('User email: $fireEmail');

      // Firestore reference to the 'users' collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query Firestore to find the user document by email
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: fireEmail).get();

      // Check if a matching document is found
      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;

        // Retrieve address (latitude, longitude) from Firestore
        String? address = userDoc.get('address');
        if (address == null) {
          print('Address is missing.');
          setState(() {
            isLoading = false;
          });
          return;
        }

        // Split the address into latitude and longitude
        List<String> latLng = address.split(',');
        if (latLng.length == 2) {
          double latitude = double.tryParse(latLng[0].trim()) ?? 0.0;
          double longitude = double.tryParse(latLng[1].trim()) ?? 0.0;

          print('Latitude: $latitude, Longitude: $longitude');

          setState(() {
            userLatitude = latitude;
            userLongitude = longitude;
            _center = LatLng(userLatitude, userLongitude);
            isLoading = false; // Stop loading once the address is fetched
          });
        } else {
          print('Invalid address format');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('No user found with that email');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11,
              ),
              onMapCreated: _onMapCreated,
              mapType: MapType.terrain,
              markers: {
                Marker(
                  markerId: MarkerId('userLocation'),
                  position: _center,
                  infoWindow: InfoWindow(title: 'My Location'),
                ),
              },
            ),
    );
  }
}
