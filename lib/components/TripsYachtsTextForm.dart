import 'package:flutter/material.dart';

class TripsYachtsTextForm extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Function()? onTap;
  final bool? readOnly;
  final suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const TripsYachtsTextForm({
    super.key,
    required this.hintText,
    required this.labelText,
    this.onTap,
    this.controller,
    this.readOnly,
    this.suffixIcon,
    this.keyboardType, required int maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: TextField(
        readOnly: readOnly ?? false,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
        onTap: onTap,
        keyboardType: keyboardType,
      ),
    );
  }
}
