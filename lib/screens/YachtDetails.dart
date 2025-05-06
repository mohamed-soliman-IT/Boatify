import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class YachtDetails extends StatefulWidget {
  final String yachtId;
  final String image;
  final String price;
  final String brand;
  final String modelNo;
  final String co2;
  final String fuelCons;
  final String OwnerName;
  final String description;
  const YachtDetails({
    super.key,
    required this.yachtId,
    required this.image,
    required this.price,
    required this.brand,
    required this.modelNo,
    required this.co2,
    required this.fuelCons,
    required this.OwnerName,
    required this.description,
  });
  @override
  State<YachtDetails> createState() => _YachtDetailsState();
}

class _YachtDetailsState extends State<YachtDetails> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  final PageController _pageController = PageController();
  int currentPage = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> imagePaths = [
    'assets/images/yachtDetails.jpg',
    'assets/images/yachtDetails.jpg',
    'assets/images/yachtDetails.jpg',
  ];

  Future<void> selectDate(BuildContext context, bool isCheckIn) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = pickedDate;
        } else {
          checkOutDate = pickedDate;
        }
      });
    }
  }

  Future<void> _createBookingRequest() async {
    if (checkInDate == null || checkOutDate == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        title: 'Missing Dates',
        desc: 'Please select both check-in and check-out dates',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    if (checkOutDate!.isBefore(checkInDate!)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Invalid Dates',
        desc: 'Check-out date must be after check-in date',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Authentication Error',
          desc: 'Please login to book a yacht',
          btnOkOnPress: () {},
        ).show();
        return;
      }

      // Get user data
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userData.exists) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'User Error',
          desc: 'User profile not found',
          btnOkOnPress: () {},
        ).show();
        return;
      }

      Map<String, dynamic> userDataMap =
          userData.data() as Map<String, dynamic>;

      // Create booking request
      await _firestore.collection('yachtRentRequests').add({
        'userId': currentUser.uid,
        'userName': userDataMap['name'],
        'userEmail': currentUser.email,
        'userPhone': userDataMap['phone'],
        'yachtId': widget.yachtId,
        'yachtBrand': widget.brand,
        'yachtModel': widget.modelNo,
        'checkInDate': Timestamp.fromDate(checkInDate!),
        'checkOutDate': Timestamp.fromDate(checkOutDate!),
        'totalPrice': widget.price,
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Your booking request has been submitted successfully',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Failed to submit booking request: ${e.toString()}',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 54, 77),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.45,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: imagePaths.length,
                  onPageChanged: (index) => setState(() => currentPage = index),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePaths[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color.fromARGB(255, 26, 54, 77).withOpacity(0.8),
                        const Color.fromARGB(255, 26, 54, 77),
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: imagePaths.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.white.withOpacity(0.3),
                        activeDotColor: Colors.white,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                        expansionFactor: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.38),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 26, 54, 77),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.brand,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Model: ${widget.modelNo}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    '\$${widget.price}/day',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSpecItem(
                                    Icons.speed_rounded,
                                    'Speed',
                                    widget.co2,
                                    'km/h',
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.white24,
                                  ),
                                  _buildSpecItem(
                                    Icons.local_gas_station_rounded,
                                    'Fuel Cons.',
                                    widget.fuelCons,
                                    'L/100km',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.description,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                        'assets/images/yachtDetails.jpg'),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Owner',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        widget.OwnerName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Dates',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(child: _buildDateSelector(true)),
                                SizedBox(width: 15),
                                Expanded(child: _buildDateSelector(false)),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "\$${widget.price}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _createBookingRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(
      IconData icon, String label, String value, String unit) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          '$value $unit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(bool isCheckIn) {
    return GestureDetector(
      onTap: () => selectDate(context, isCheckIn),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCheckIn ? "Check-in" : "Check-out",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  isCheckIn
                      ? (checkInDate?.toString().split(' ')[0] ?? "Select")
                      : (checkOutDate?.toString().split(' ')[0] ?? "Select"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
