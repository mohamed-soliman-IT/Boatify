import 'package:flutter/material.dart';

class YachtCardMapPage extends StatelessWidget {
  final image;
  const YachtCardMapPage({super.key, required String this.image});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Stack(
              clipBehavior: Clip.none, // This will clip the overflow

              children: [
                Container(
                  width: size.width * 0.9,
                  
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(
                                0xFF006994), // Ocean Blue (deep part of the sea)
                            Color(
                                0xFF40E0D0), // Turquoise (lighter, shallow water)
                            Color.fromARGB(255, 30, 230,
                                126), // Seafoam Green (foam and waves)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$120',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25)),
                          Text('Price/hr',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Marserati',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Brand',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('3A 9500',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Model No.',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('77/km',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('CO2',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('5,5 L',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text('Fuel Cons.',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Book Now',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ]
                            )
                          )
                          // Row(
                          //   children: [
                          //     Image.asset(
                          //       'assets/images/av.png',
                          //       height: size.height * 0.15,
                          //     ),
                          //     SizedBox(
                          //         width:
                          //             size.width * 0.02), // Adds some space between the image and the text
                          //     Expanded(
                          //       child: Column(
                          //         children: [
                          //           const Row(
                          //             mainAxisAlignment: MainAxisAlignment
                          //                 .spaceBetween, // Ensures even spacing between columns
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.start,
                          //                 children: [
                          //                   Text('Mohamed Soliman',
                          //                       style: TextStyle(
                          //                           color: Colors.black,
                          //                           fontWeight: FontWeight.w500,
                          //                           fontSize: 15)),
                          //                   Text('License NWR 396845',
                          //                       style: TextStyle(
                          //                           color: Colors.black,
                          //                           fontWeight:
                          //                               FontWeight.w500)),
                          //                 ],
                          //               ),
                          //               Column(
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.end,
                          //                 children: [
                          //                   Text('360',
                          //                       style: TextStyle(
                          //                           color: Colors.white,
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 17)),
                          //                   Text('Ride',
                          //                       style: TextStyle(
                          //                           color: Colors.black,
                          //                           fontWeight:
                          //                               FontWeight.w500)),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(
                          //             height: size.height * 0.01,
                          //           ),
                          //           Row(
                          //             children: [
                          //               Text('5.0'),
                          //               SizedBox(
                          //                 width: size.width * 0.02,
                          //               ),
                          //               Icon(
                          //                 Icons.star,
                          //                 size: 15,
                          //               ),
                          //               Icon(
                          //                 Icons.star,
                          //                 size: 15,
                          //               ),
                          //               Icon(
                          //                 Icons.star,
                          //                 size: 15,
                          //               ),
                          //               Icon(
                          //                 Icons.star,
                          //                 size: 15,
                          //               ),
                          //               Icon(
                          //                 Icons.star,
                          //                 size: 15,
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(
                          //             height: size.height * 0.015,
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           YachtDetails()));
                          //             },
                          //             child: Container(
                          //               width: double.infinity,
                          //               decoration: BoxDecoration(
                          //                   color: const Color.fromARGB(
                          //                       255, 26, 54, 77),
                          //                   borderRadius:
                          //                       BorderRadius.circular(15)),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.fromLTRB(
                          //                     20, 5, 20, 5),
                          //                 child: Text(
                          //                   textAlign: TextAlign.center,
                          //                   'Book Now',
                          //                   style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontSize: 15,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                ),
                Positioned(
                    right: -70,
                    top: -165,
                    child: Image.asset(
                      image,
                      width: size.width * 0.90,
                    )),
              ]),
        )
      ],
    );
  }
}
