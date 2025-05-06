import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Boatify/components/colors.dart';
import 'package:Boatify/screens/TripsScreen.dart';

class Trip {
  final String id;
  final String imageUrl;
  final String passengerCount;
  final String tripDate;
  final String tripDestination;
  final String tripDuration;
  final String tripLocation;
  final String tripTitle;
  final String yachtBrand;
  final String yachtModel;
  final String yachtSpeed;
  final String tripDescription;
  final String tripPrice;
  final String yachtImageUrl;
  final String yachtOwnerName;

  Trip({
    required this.id,
    required this.imageUrl,
    required this.passengerCount,
    required this.tripDate,
    required this.tripDestination,
    required this.tripDuration,
    required this.tripLocation,
    required this.tripTitle,
    required this.yachtBrand,
    required this.yachtModel,
    required this.yachtSpeed,
    this.tripDescription = '',
    this.tripPrice = '0',
    this.yachtImageUrl = '',
    this.yachtOwnerName = '',
  });

  factory Trip.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Trip(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      passengerCount: data['passengerCount'] ?? '0',
      tripDate: data['tripDate'] ?? '',
      tripDestination: data['tripDestination'] ?? '',
      tripDuration: data['tripDuration'] ?? '0',
      tripLocation: data['tripLocation'] ?? '',
      tripTitle: data['tripTitle'] ?? '',
      yachtBrand: data['yachtBrand'] ?? '',
      yachtModel: data['yachtModel'] ?? '',
      yachtSpeed: data['yachtSpeed'] ?? '0',
      tripDescription: data['tripDestination'] ?? '',
      tripPrice: data['tripPrice'] ?? '0',
      yachtImageUrl: data['imageUrl'] ?? '',
      yachtOwnerName: data['yachtBrand'] ?? '',
    );
  }
}

class Trips extends StatelessWidget {
  final String searchQuery;

  const Trips({
    super.key,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Trips')
          .where('processed', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No trips available.'));
        }

        List<Trip> trips = snapshot.data!.docs
            .map((doc) => Trip.fromFirestore(doc))
            .where((trip) {
          if (searchQuery.isEmpty) return true;
          return trip.tripLocation.toLowerCase().contains(searchQuery) ||
              trip.tripDestination.toLowerCase().contains(searchQuery) ||
              trip.tripTitle.toLowerCase().contains(searchQuery);
        }).toList();

        if (trips.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No trips found for "$searchQuery"',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: trips.map((trip) => PlacesCard(trip: trip)).toList(),
          ),
        );
      },
    );
  }
}

class PlacesCard extends StatelessWidget {
  final Trip trip;
  const PlacesCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripsScreen(trip: trip),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Stack(
          children: [
            Container(
              width: 250,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.SlateGrayText, width: 0.5),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: trip.imageUrl.isNotEmpty
                      ? NetworkImage(trip.imageUrl)
                      : AssetImage('assets/images/yachtDetails.jpg')
                          as ImageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.tripTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        trip.tripDate,
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.timer,
                        '${trip.tripDuration} days',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
