
import 'package:flutter/material.dart';

class Brands extends StatelessWidget {
  const Brands({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/RoyalLogopng.png'),
                ),

                // backgroundImage: AssetImage('assets/images/RoyalLogopng.png'),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/RoyalLogopng.png'),
                ),

                // backgroundImage: AssetImage('assets/images/RoyalLogopng.png'),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/RoyalLogopng.png'),
                ),

                // backgroundImage: AssetImage('assets/images/RoyalLogopng.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
