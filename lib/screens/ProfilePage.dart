import 'dart:convert';
import 'package:Boatify/components/colors.dart';
import 'package:Boatify/screens/GetStart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String User_Address = 'Loading...';
  final ImagePicker _imagePicker = ImagePicker();
  // ignore: unused_field
  XFile? _pickedImage;

  Future<void> _pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = image != null ? XFile(image.path) : null;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    GetUserAddress();
  }

  Future<Map<String, String>> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('No user is logged in.');
      return {'name': 'No Name', 'email': 'No Email'};
    }
    String fireEmail =
        currentUser.email ?? ''; // Use an empty string if email is null.

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Query Firestore to find the user document by email
    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: fireEmail) // Match the email field
        .get();

    // Check if any document matched the query
    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;

      String name = userDoc.get('name') ?? 'No Name'; // Default if name is null
      String phone =
          userDoc.get('phone') ?? 'No phone'; // Default if name is null
      String email = currentUser.email ?? 'No Email'; // Use currentUser's email
      return {'name': name, 'email': email, 'phone': phone};
    } else {
      return {'name': 'No Name', 'email': 'No Email'};
    }
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/yachtDetails.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.23,
                  ),
                  Stack(children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/yachtOrTrip.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _pickImageFromGallery();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.SlateGrayText,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  // Use FutureBuilder to fetch and display the user's name and email
                  FutureBuilder<Map<String, String>>(
                    future: fetchUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading spinner while fetching data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        String name = snapshot.data?['name'] ?? 'No Name';
                        String email = snapshot.data?['email'] ?? 'No Email';
                        String phone = snapshot.data?['phone'] ?? 'No phone';

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$name',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      TextEditingController nameController =
                                          TextEditingController(text: name);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Edit Name',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18)),
                                              content: TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  hintText: 'Enter new name',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    String newName =
                                                        nameController.text
                                                            .trim();

                                                    if (newName.isNotEmpty) {
                                                      User? currentUser =
                                                          FirebaseAuth.instance
                                                              .currentUser;
                                                      if (currentUser != null) {
                                                        CollectionReference
                                                            usersCollection =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users');
                                                        QuerySnapshot
                                                            querySnapshot =
                                                            await usersCollection
                                                                .where('email',
                                                                    isEqualTo:
                                                                        currentUser
                                                                            .email)
                                                                .get();
                                                        if (querySnapshot
                                                            .docs.isNotEmpty) {
                                                          querySnapshot.docs
                                                              .first.reference
                                                              .update({
                                                            'name': newName
                                                          });
                                                        }

                                                        setState(() {
                                                          name = newName;
                                                        });
                                                      }
                                                    }

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Save'),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                    )),
                              ],
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            ProfileDataCard(
                              size: size,
                              title: phone,
                              leadingIcon: Icons.phone,
                              trailingIcon: Icons.edit_note,
                              onTap: () async {
                                TextEditingController phoneController =
                                    TextEditingController(text: phone);

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Edit Phone Number',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                      content: TextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new phone number',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            String newPhone =
                                                phoneController.text.trim();
                                            if (newPhone.isNotEmpty) {
                                              // Get current user
                                              User? currentUser = FirebaseAuth
                                                  .instance.currentUser;
                                              if (currentUser != null) {
                                                // Update Firestore
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .where('email',
                                                        isEqualTo:
                                                            currentUser.email)
                                                    .get()
                                                    .then((querySnapshot) {
                                                  if (querySnapshot
                                                      .docs.isNotEmpty) {
                                                    querySnapshot
                                                        .docs.first.reference
                                                        .update({
                                                      'phone': newPhone
                                                    });
                                                  }
                                                });

                                                // Update UI
                                                setState(() {
                                                  phone = newPhone;
                                                });
                                              }
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            ProfileDataCard(
                              size: size,
                              title: User_Address,
                              leadingIcon: Icons.location_on,
                              trailingIcon: Icons.edit_note,
                            ),
                            ProfileDataCard(
                              size: size,
                              leadingIcon: Icons.favorite,
                              title: 'Favorites',
                              trailingIcon: Icons.arrow_forward_ios,
                              onTap: () async {},
                            ),
                            ProfileDataCard(
                              size: size,
                              leadingIcon: Icons.logout,
                              title: 'Logout',
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Getstart()));
                              },
                            ),
                          ],
                        );
                      } else {
                        return Text('No data available');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDataCard extends StatelessWidget {
  final String? title;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  const ProfileDataCard({
    super.key,
    required this.size,
    this.title = 'Edit Profile',
    this.leadingIcon,
    this.trailingIcon,
    this.onTap,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.9,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: AppColors.DeepBlueButton,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: ListTile(
            leading: Icon(
              leadingIcon,
              color: Colors.white,
            ),
            title: Text(
              title!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              trailingIcon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
