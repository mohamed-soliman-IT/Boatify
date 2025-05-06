import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Boatify/components/colors.dart';
import '../components/Trips.dart';
import '../components/yachtcards.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
// To make HTTP requests

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String Address = 'Loading...';
  String userCity = '';
  double? userLat;
  double? userLon;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _searchController.addListener(_onSearchChanged);
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

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
    });
  }

  // 30.016893 ,31.377033
  Future<void> GetUserAddress() async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLat = position.latitude;
        userLon = position.longitude;
      });

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
            userCity = data['address']['city'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.005),
              child: Column(
                children: [
                  Row(
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
                            border: Border.all(
                              color: Colors.black,
                            )),
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
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 18, left: 10, right: 50),
                    child: Text(
                      'Search for your location to find the best yacht for you',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: size.height * 0.06,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.black, size: 30),
                                suffixIcon: _isSearching
                                    ? IconButton(
                                        icon: Icon(Icons.clear,
                                            color: Colors.black, size: 20),
                                        onPressed: () {
                                          _searchController.clear();
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 2),
                                ),
                                labelStyle: TextStyle(
                                    backgroundColor: Colors.transparent),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                                labelText: 'Search for your location',
                                hintText: 'ex: Sharm El Sheikh',
                                alignLabelWithHint: false,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                            ),
                          ),
                        ),
                        SizedBox(width: size.height * 0.01),
                        Container(
                          width: 50,
                          height: size.height * 0.06,
                          child: Icon(
                            Icons.location_pin,
                            size: 30,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.DeepBlueButton,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.34),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 54, 77),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 25, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _isSearching ? 'Search Results' : 'Suggested Trips',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Trips(searchQuery: _searchQuery),
                      SizedBox(height: 25),
                      if (_isSearching) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Yachts',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        YachtList(
                          searchQuery: _searchQuery,
                          userLat: userLat,
                          userLon: userLon,
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Suggested Yachts',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        YachtList(
                          searchQuery: _searchQuery,
                          userLat: userLat,
                          userLon: userLon,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
