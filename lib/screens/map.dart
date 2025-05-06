import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/GoogleMapWidget.dart';
import '../components/YachtCardMapPage.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String Address = 'Loading...';
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  void _initializeLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    // Get initial location
    await GetUserAddress();

    // Set up periodic location updates (every 30 minutes)
    _locationTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      GetUserAddress();
    });
  }

  Future<void> GetUserAddress() async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the current user's email
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in.');
        return;
      }

      String fireEmail = currentUser.email ?? '';

      // Update user's location in Firestore
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: fireEmail).get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await usersCollection.doc(docId).update({
          'address': '${position.latitude},${position.longitude}',
        });
      }

      // Get address from coordinates using the API
      String apiUrl =
          'https://geocode.maps.co/reverse?lat=${position.latitude}&lon=${position.longitude}&api_key=679e58ed01191569426739muo67c864';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data != null && data['address'] != null) {
          String customAddress =
              '${data['address']['city']}, ${data['address']['country']}';

          setState(() {
            Address = customAddress;
          });
        }
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none, // This will clip the overflow
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMapWidget(),
          ),
          YachtCardMapPage(
            image: 'assets/images/Yacht1.png',
          ),
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black45,
                    size: 30,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Location',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      Address.length > 25
                          ? '${Address.substring(0, 20)}...'
                          : Address, // Display the address value
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                Spacer(), // This pushes the CircleAvatar to the right
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(
                    //   color: Colors.black,
                    // )
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('assets/images/Boatify.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
