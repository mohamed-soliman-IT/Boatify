import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustopAppBar extends StatefulWidget {
  final Size size;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final String address;

  const CustopAppBar({
    Key? key,
    required this.size,
    required this.searchController,
    required this.onSearchChanged,
    required this.address,
  }) : super(key: key);

  @override
  State<CustopAppBar> createState() => _CustopAppBarState();
}

class _CustopAppBarState extends State<CustopAppBar> {
  String User_Address = 'Loading...';

  @override
  void initState() {
    super.initState();
    GetUserAddress();
  }

  Future<void> GetUserAddress() async {
    try {
      // Get the current user's email, and check for null.
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in.');
        return;
      }

      String fireEmail =
          currentUser.email ?? ''; // Use an empty string if email is null.
      print('User email: $fireEmail');

      // Reference to the Firestore collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query Firestore to find the user document by email
      QuerySnapshot querySnapshot = await usersCollection
          .where('email', isEqualTo: fireEmail) // Match the email field
          .get();

      // Check if any document matched the query
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document that matches
        var userDoc = querySnapshot.docs.first;

        // Retrieve the address from the document (latitude, longitude)
        String? address =
            userDoc.get('address'); // Make it nullable to handle missing values
        if (address == null) {
          print('Address is missing.');
          return;
        }

        print('User address: $address');

        // Split the address into latitude and longitude
        List<String> latLng = address.split(','); // Split by the comma
        if (latLng.length == 2) {
          double latitude =
              double.tryParse(latLng[0].trim()) ?? 0.0; // Safely parse latitude
          double longitude = double.tryParse(latLng[1].trim()) ??
              0.0; // Safely parse longitude

          // Print the extracted latitude and longitude
          print('Latitude: $latitude, Longitude: $longitude');

          // Use the external API to get the address from latitude and longitude
          String apiUrl =
              'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude&api_key=679e58ed01191569426739muo67c864';
          final response = await http.get(Uri.parse(apiUrl));

          if (response.statusCode == 200) {
            // If the request is successful, parse the JSON
            var data = json.decode(response.body);
            if (data != null && data['address'] != null) {
              // Construct the full address from the returned data
              String fullAddress =
                  '${data['address']['road']}, ${data['address']['city']}, ${data['address']['country']}';
              String customAddress =
                  '${data['address']['city']}, ${data['address']['country']}';

              setState(() {
                User_Address = customAddress;
              });

              // Update the address variable with the custom address

              print('Full Address: $fullAddress');
            } else {
              print('No address found for the given coordinates.');
            }
          } else {
            print('Error fetching address from API: ${response.statusCode}');
          }
        } else {
          print('Invalid address format');
        }
      } else {
        print('No user found with that email');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.size.height * 0.02),
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
                    widget.address.length > 25
                        ? '${widget.address.substring(0, 20)}...'
                        : widget.address,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                  ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: widget.size.height * 0.06,
                    child: TextField(
                      controller: widget.searchController,
                      onChanged: widget.onSearchChanged,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.search, color: Colors.black, size: 30),
                        suffixIcon: widget.searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear,
                                    color: Colors.black, size: 20),
                                onPressed: () {
                                  widget.searchController.clear();
                                  widget.onSearchChanged('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 2),
                        ),
                        labelStyle:
                            TextStyle(backgroundColor: Colors.transparent),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        labelText: 'Search for your location',
                        hintText: 'ex: Sharm El Sheikh',
                        alignLabelWithHint: false,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
                SizedBox(width: widget.size.height * 0.01),
                Container(
                  width: 50,
                  height: widget.size.height * 0.06,
                  child: Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 26, 54, 77),
                    borderRadius: BorderRadius.circular(10),
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
