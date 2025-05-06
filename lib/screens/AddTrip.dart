import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/Bottomnav.dart';
import '../components/TripsYachtsTextForm.dart';
import '../components/colors.dart';

class AddTrip extends StatefulWidget {
  const AddTrip({super.key});

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final TextEditingController tripDateController = TextEditingController();
  final TextEditingController tripDestinationController =
      TextEditingController();
  final TextEditingController passengerCountController =
      TextEditingController();
  final TextEditingController tripDurationController = TextEditingController();
  final TextEditingController yachtBrandController = TextEditingController();
  final TextEditingController yachtModelController = TextEditingController();
  final TextEditingController yachtSpeedController = TextEditingController();
  final TextEditingController triplocationController = TextEditingController();
  bool isChecked = false;
  List<XFile> _imageFiles = [];
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _imageFiles.addAll(images);
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      if (_currentImageIndex >= _imageFiles.length) {
        _currentImageIndex = _imageFiles.length - 1;
      }
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // Reset method to clear all fields and image
  void _resetFields() {
    setState(() {
      tripDateController.clear();
      tripDestinationController.clear();
      passengerCountController.clear();
      tripDurationController.clear();
      yachtBrandController.clear();
      yachtModelController.clear();
      yachtSpeedController.clear();
      triplocationController.clear();
      _imageFiles.clear();
      isChecked = false;
    });
  }

  Future<void> _uploadData() async {
    if (tripDateController.text.isEmpty ||
        tripDestinationController.text.isEmpty ||
        passengerCountController.text.isEmpty ||
        tripDurationController.text.isEmpty ||
        yachtBrandController.text.isEmpty ||
        yachtModelController.text.isEmpty ||
        yachtSpeedController.text.isEmpty ||
        triplocationController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Please fill in all fields and upload an image',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      // Upload the form data to Firestore
      await FirebaseFirestore.instance.collection('Trips').add({
        'triplocation': 'triplocation',
        'tripDate': tripDateController.text,
        'tripDestination': tripDestinationController.text,
        'passengerCount': passengerCountController.text,
        'tripDuration': tripDurationController.text,
        'yachtBrand': yachtBrandController.text,
        'yachtModel': yachtModelController.text,
        'yachtSpeed': yachtSpeedController.text,
        'processed': isChecked,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Trip Added Successfully',
        desc: 'Thank you for adding the trip details.',
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Failed to upload data. Please try again later.',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.DeepBlueButton,
        elevation: 0,
        title: Text(
          "Add Trip",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _resetFields,
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            _buildImagePreview(),
            _buildFormSection(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 35, 15, 10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: _imageFiles.isEmpty
          ? InkWell(
              onTap: _pickImages,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.DeepBlueButton.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: AppColors.DeepBlueButton,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Add Trip Images",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap to browse",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _imageFiles.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(_imageFiles[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Image counter
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${_imageFiles.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Add more images button
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: InkWell(
                    onTap: _pickImages,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.DeepBlueButton,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Remove image button
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () => _removeImage(_currentImageIndex),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trip Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          TripsYachtsTextForm(
            hintText: 'ex. Sharm El Sheikh',
            labelText: 'Trip Location',
            controller: triplocationController,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            suffixIcon: Icon(Icons.calendar_month),
            hintText: 'Trip Date',
            labelText: 'Trip Date',
            onTap: () => _selectDate(context, tripDateController),
            readOnly: true,
            controller: tripDateController,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            hintText: 'Enter Trip Destination',
            labelText: 'Trip Destination',
            controller: tripDestinationController,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            hintText: 'Enter Number of Passengers',
            labelText: 'Passenger Count',
            controller: passengerCountController,
            keyboardType: TextInputType.number,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            hintText: 'Enter Trip Duration (Days)',
            labelText: 'Trip Duration',
            controller: tripDurationController,
            keyboardType: TextInputType.number,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Brand Used',
            labelText: 'Yacht Brand',
            controller: yachtBrandController,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Model',
            labelText: 'Yacht Model',
            controller: yachtModelController,
                        maxLines: 4,

          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Speed',
            labelText: 'Yacht Speed (Knots)',
            controller: yachtSpeedController,
            keyboardType: TextInputType.number,
                        maxLines: 4,

          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
              Flexible(
                child: const Text(
                  'Processing will take approximately 1-2 days.',
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: _uploadData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.DeepBlueButton,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          "Submit Trip Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
