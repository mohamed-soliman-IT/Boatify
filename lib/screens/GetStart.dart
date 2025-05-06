import 'package:flutter/material.dart';
import '../components/colors.dart';
import 'registerType.dart';

class Getstart extends StatelessWidget {
  const Getstart({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 160, 151),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: AppColors.SeaGradient),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcom To ',
                    style: TextStyle(
                        color: Colors.white, // Set the color to yellow
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Yacht Rental',
                    style: TextStyle(
                        color: Colors.white, // Set the color to yellow
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 5),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.38),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 26, 54, 77),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(35))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 170, 25, 0),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text:
                            'We Bring The Best Yacht for You as an', // Default style
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Enthusiast', // Specific style for "Enthusiast"
                            style: TextStyle(
                              color: const Color.fromARGB(
                                  255, 70, 179, 223), // Set the color to yellow
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
                      style: TextStyle(
                        color: Colors.white60, // Set the color to yellow
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5,
                              50), // 10 padding left and right, 50 bottom
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterType()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      12.0), // Add vertical padding for the button's height
                              child: Text(
                                'Join Us Now', // Replace with your desired text
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 99, 209, 224),
                              minimumSize: Size(double.infinity,
                                  0), // Set button width to full with minimum height
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: size.height * 0.040,
              left: -size.width * 0.48,
              right: 0,
              child: Image.asset(
                'assets/images/Yacht1.png',
                height: size.height * 0.71,
              )),
        ],
      ),
    );
  }
}
