import 'package:Boatify/components/colors.dart';
import 'package:flutter/material.dart';

class HoppiesCards extends StatelessWidget {
  final String? title;
  final IconData? icon;

  const HoppiesCards({
    super.key, this.title, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(40.0),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: AppColors.LightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.sailing,
            size: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 10),
          child: Text(
            title!,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}