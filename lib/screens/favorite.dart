import 'package:flutter/material.dart';
import 'GetStart.dart';
import 'login.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 54, 77),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Getstart()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Yacht Rental',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              )),
        ],
      ),
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: ScreenSize.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/island-back.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.06,
                ),
                YachtCard(
                  image: 'assets/images/y2.png',
                ),
                YachtCard(
                  image: 'assets/images/y3.png',
                ),
                YachtCard(
                  image: 'assets/images/y2.png',
                ),
                YachtCard(
                  image: 'assets/images/y3.png',
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class YachtCard extends StatelessWidget {
  final String image;
  const YachtCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 50),
          child: Stack(
              clipBehavior: Clip.none, // This allows overflow
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 26, 54, 77),
                      borderRadius: BorderRadius.circular(25)),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
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
                          height: 20,
                        ),
                        Row(
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
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    right: -70,
                    top: -180,
                    child: Image.asset(
                      image,
                      width: 350,
                    )),
              ]),
        )
      ],
    );
  }
}
