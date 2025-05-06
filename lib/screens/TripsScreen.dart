import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../components/Trips.dart'; // Import the Trip model
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TripsScreen extends StatefulWidget {
  final Trip trip; // Add this parameter

  const TripsScreen({
    super.key,
    required this.trip, // Add this required parameter
  });

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  final PageController _pageController = PageController();
  int currentPage = 0;
  final TextEditingController _passengersController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> imagePaths = [
    'assets/images/yachtDetails.jpg',
    'assets/images/yachtDetails.jpg',
    'assets/images/yachtDetails.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageCarousel(screenSize),
            _buildTripDetails(screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(Size screenSize) {
    return Container(
      height: screenSize.height * 0.45,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.trip.imageUrl.isNotEmpty
                        ? NetworkImage(widget.trip.imageUrl)
                        : AssetImage('assets/images/yachtDetails.jpg')
                            as ImageProvider,
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
                  Colors.black.withOpacity(0.7),
                ],
                stops: [0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  widget.trip.tripTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.white.withOpacity(0.3),
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                    expansionFactor: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(Size screenSize) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOwnerSection(),
          SizedBox(height: 25),
          _buildTripInfoSection(),
          SizedBox(height: 25),
          _buildBookingSection(),
        ],
      ),
    );
  }

  Widget _buildOwnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trip Host",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: widget.trip.imageUrl.isNotEmpty
                  ? NetworkImage(widget.trip.imageUrl)
                  : AssetImage('assets/images/yachtDetails.jpg')
                      as ImageProvider,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.trip.yachtBrand,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Professional Captain",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTripInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trip Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                  Icons.location_on, "Location", widget.trip.tripLocation),
              Divider(color: Colors.white24, height: 30),
              _buildInfoRow(Icons.schedule, "Duration",
                  "${widget.trip.tripDuration} days"),
              Divider(color: Colors.white24, height: 30),
              _buildInfoRow(
                  Icons.group, "Max Passengers", widget.trip.passengerCount),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book Your Trip",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passengersController,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Number of Passengers",
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
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
                "Total Price",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(
                "\$${widget.trip.passengerCount}",
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
            height: 50,
            child: ElevatedButton(
              onPressed: _handleBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Book Now",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(bool isCheckIn) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: isCheckIn
                ? DateTime.now()
                : (checkInDate ?? DateTime.now()).add(const Duration(days: 1)),
            firstDate: isCheckIn
                ? DateTime.now()
                : (checkInDate ?? DateTime.now()).add(const Duration(days: 1)),
            lastDate:
                DateTime(2100), // Extended to 2100 for better future planning
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Color.fromARGB(255, 26, 54, 77),
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: Color.fromARGB(255, 26, 54, 77),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            setState(() {
              if (isCheckIn) {
                if (checkOutDate != null && picked.isAfter(checkOutDate!)) {
                  checkOutDate = null;
                }
                checkInDate = picked;
              } else {
                if (checkInDate == null) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.topSlide,
                    title: 'Select Check-in First',
                    desc:
                        'Please select a check-in date before selecting check-out date',
                    btnOkOnPress: () {},
                  ).show();
                  return;
                }
                if (picked.isBefore(checkInDate!) ||
                    picked.isAtSameMomentAs(checkInDate!)) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    title: 'Invalid Date',
                    desc: 'Check-out date must be after check-in date',
                    btnOkOnPress: () {},
                  ).show();
                  return;
                }
                checkOutDate = picked;
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isCheckIn ? "Check-in" : "Check-out",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isCheckIn
                          ? (checkInDate?.toString().split(' ')[0] ?? "Select")
                          : (checkOutDate?.toString().split(' ')[0] ??
                              "Select"),
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleBooking() async {
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

    if (_passengersController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        title: 'Missing Information',
        desc: 'Please enter the number of passengers',
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
          desc: 'Please login to book a trip',
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

      // Calculate total price
      int numberOfDays = checkOutDate!.difference(checkInDate!).inDays;
      int passengers = int.tryParse(_passengersController.text) ?? 0;
      double totalPrice =
          numberOfDays * double.parse(widget.trip.passengerCount) * passengers;

      // Create trip booking request
      await _firestore.collection('triprequests').add({
        'userId': currentUser.uid,
        'userName': userDataMap['name'],
        'userEmail': currentUser.email,
        'userPhone': userDataMap['phone'],
        'tripId': widget.trip.id,
        'tripTitle': widget.trip.tripTitle,
        'tripLocation': widget.trip.tripLocation,
        'tripDuration': widget.trip.tripDuration,
        'numberOfPassengers': passengers,
        'checkInDate': Timestamp.fromDate(checkInDate!),
        'checkOutDate': Timestamp.fromDate(checkOutDate!),
        'totalPrice': totalPrice,
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Your trip booking request has been submitted successfully',
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
}
