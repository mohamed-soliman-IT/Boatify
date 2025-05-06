import 'dart:async';
import 'package:flutter/material.dart';
import '../components/Trips.dart';
import '../components/CustopAppBarAllTrips.dart';
import '../components/HoppiesCards.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllTripsPage extends StatefulWidget {
  const AllTripsPage({super.key});

  @override
  State<AllTripsPage> createState() => _AllTripsPageState();
}

class _AllTripsPageState extends State<AllTripsPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
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
    _searchController.dispose();
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

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustopAppBar(
                  size: size,
                  searchController: _searchController,
                  onSearchChanged: onSearchChanged,
                  address: Address,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    'What you want to do?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HoppiesCards(
                            title: 'Sailing',
                            icon: Icons.sailing,
                          ),
                          HoppiesCards(
                            title: 'Fishishing',
                            icon: Icons.sailing,
                          ),
                          HoppiesCards(
                            title: 'Snorkeling',
                            icon: Icons.sailing,
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 25),
                  child: Text(
                    'Browse All Trips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 15, bottom: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Trips(searchQuery: searchQuery),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
