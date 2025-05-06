import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Boatify/components/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/YachtDetails.dart';

// Helper function to calculate distance between two points
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // Earth's radius in kilometers
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _toRadians(double degree) {
  return degree * (pi / 180);
}

class YachtCard extends StatelessWidget {
  final DocumentSnapshot yacht;
  const YachtCard({super.key, required this.yacht});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final data = yacht.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YachtDetails(
              yachtId: yacht.id,
              image: 'assets/images/y2.png',
              price: data['amount'] ?? '0',
              brand: data['YachtBrand'] ?? 'Unknown',
              modelNo: data['YachtModel'] ?? 'Unknown',
              co2: data['Yachtspeed'] ?? '0',
              fuelCons: data['YachtIndividual'] ?? '0',
              OwnerName: data['OwnerName'] ?? 'Unknown',
              description: data['description'] ?? 'No description available',
            ),
          ),
        );
      },
      child: SizedBox(
        width: size.width * 0.65,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 10, 30),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['YachtBrand'] ?? 'Unknown Brand',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        data['city'] ?? 'Unknown Location',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${data['amount'] ?? '0'}\$/day',
                                    style: TextStyle(
                                      color: AppColors.PremiumFeature,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    top: -120,
                    child: Image.asset(
                      'assets/images/y2.png',
                      width: 250,
                    ),
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

class YachtList extends StatelessWidget {
  final String searchQuery;
  final double? userLat;
  final double? userLon;

  const YachtList({
    super.key,
    this.searchQuery = '',
    this.userLat,
    this.userLon,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('YachtCollection').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No yachts available'));
        }

        var yachts = snapshot.data!.docs.where((yacht) {
          var data = yacht.data() as Map<String, dynamic>;

          // If there's a search query, filter by it
          if (searchQuery.isNotEmpty) {
            return (data['YachtBrand'] ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                (data['YachtModel'] ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                (data['description'] ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                (data['city'] ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
          }

          return true;
        }).toList();

        // Sort yachts by distance if user location is available
        if (userLat != null && userLon != null) {
          yachts.sort((a, b) {
            var dataA = a.data() as Map<String, dynamic>;
            var dataB = b.data() as Map<String, dynamic>;

            String? locationA = dataA['location'];
            String? locationB = dataB['location'];

            if (locationA == null || locationB == null) return 0;

            List<String> coordsA = locationA.split(',');
            List<String> coordsB = locationB.split(',');

            if (coordsA.length != 2 || coordsB.length != 2) return 0;

            double latA = double.tryParse(coordsA[0].trim()) ?? 0;
            double lonA = double.tryParse(coordsA[1].trim()) ?? 0;
            double latB = double.tryParse(coordsB[0].trim()) ?? 0;
            double lonB = double.tryParse(coordsB[1].trim()) ?? 0;

            double distanceA =
                calculateDistance(userLat!, userLon!, latA, lonA);
            double distanceB =
                calculateDistance(userLat!, userLon!, latB, lonB);

            return distanceA.compareTo(distanceB);
          });
        }

        if (yachts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'No yachts found',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  if (searchQuery.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      'for "$searchQuery"',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: yachts.map((yacht) => YachtCard(yacht: yacht)).toList(),
          ),
        );
      },
    );
  }
}
