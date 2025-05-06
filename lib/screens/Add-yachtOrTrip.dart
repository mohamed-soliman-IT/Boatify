import 'package:flutter/material.dart';
import 'package:Boatify/screens/AddYacht.dart';
import 'AddTrip.dart';

class YachOrTrip extends StatefulWidget {
  const YachOrTrip({super.key});

  @override
  State<YachOrTrip> createState() => _YachOrTripState();
}

class _YachOrTripState extends State<YachOrTrip> {
  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children:[ Container(
              height: size.height * 0.72,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/yachtOrTrip.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
            ),

            ]
          ),
          SizedBox(height: size.height * 0.02),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Yacht or Trip',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                )),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.sailing,
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 30,
            )
          ]),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 6, 87, 153),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddYachtPage()));
                          },
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 2),
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: const Color.fromARGB(96, 90, 90, 90),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Yacht',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => AddTrip()));
                          },
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Trip',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}