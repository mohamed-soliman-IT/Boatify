import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Boatify/screens/YachtDetails.dart';

class YachtCardMapPage extends StatelessWidget {
  final String image;

  const YachtCardMapPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('YachtCollection').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        var yachtList = snapshot.data!.docs;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: yachtList.length,
                  itemBuilder: (context, index) {
                    var yachtDoc = yachtList[index];
                    var yachtData = yachtDoc.data() as Map<String, dynamic>;

                    String yachtId = yachtDoc.id; // Unique document ID
                    String price = yachtData['amount'] ?? '\$120';
                    String brand = yachtData['YachtBrand'] ?? 'Unknown';
                    String modelNo = yachtData['YachtModel'] ?? 'Unknown';
                    String co2 = yachtData['Yachtspeed'] ?? 'Unknown';
                    String fuelCons = yachtData['YachtIndividual'] ?? 'Unknown';
                    String OwnerName = yachtData['OwnerName'] ?? 'Unknown';
                    String description = yachtData['description'] ?? 'Unknown';

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YachtDetails(
                                yachtId: yachtId,
                                image:
                                    image, // Use the dynamic image path if available in Firestore
                                price: price,
                                brand: brand,
                                modelNo: modelNo,
                                co2: co2,
                                fuelCons: fuelCons, OwnerName: OwnerName,
                                description: description,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: size.width * 0.9,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF006994),
                                    Color(0xFF40E0D0),
                                    Color.fromARGB(255, 30, 230, 126),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 30, 25, 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(price,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25)),
                                    const Text('Price/hr',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(height: size.height * 0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _infoColumn('Brand', brand),
                                        _infoColumn('Model No.', modelNo),
                                        _infoColumn('CO2', co2),
                                        _infoColumn('Fuel Cons.', fuelCons),
                                      ],
                                    ),
                                    const Divider(color: Colors.black),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: size.width * 0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: -10,
                              top: -165,
                              child: Image.asset(
                                image,
                                width: size.width * 0.90,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
