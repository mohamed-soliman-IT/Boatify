import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/Bottomnav.dart';
import '../components/TripsYachtsTextForm.dart';
import '../components/colors.dart';

class AddYachtPage extends StatefulWidget {
  const AddYachtPage({super.key});

  @override
  State<AddYachtPage> createState() => _AddYachtPageState();
}

class _AddYachtPageState extends State<AddYachtPage> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController OwnerNumberController = TextEditingController();
  final TextEditingController YachtBrandController = TextEditingController();
  final TextEditingController YachtModelController = TextEditingController();
  final TextEditingController YachtIndividualController =
      TextEditingController();
  final TextEditingController YachtspeedController = TextEditingController();
  final TextEditingController OwnerNameController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

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
      dobController.clear();
      amountController.clear();
      OwnerNumberController.clear();
      YachtBrandController.clear();
      YachtModelController.clear();
      YachtIndividualController.clear();
      YachtspeedController.clear();
      OwnerNameController.clear();
      DescriptionController.clear();
      locationController.clear();
      _imageFiles.clear();
      isChecked = false;
    });
  }

  Future<void> _uploadData() async {
    if (_imageFiles.isEmpty ||
        dobController.text.isEmpty ||
        amountController.text.isEmpty ||
        OwnerNumberController.text.isEmpty ||
        YachtBrandController.text.isEmpty ||
        YachtModelController.text.isEmpty ||
        YachtIndividualController.text.isEmpty ||
        YachtspeedController.text.isEmpty ||
        OwnerNameController.text.isEmpty ||
        DescriptionController.text.isEmpty ||
        locationController.text.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Please fill in all fields and add at least one image',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      // Upload form data to Firestore
      await FirebaseFirestore.instance.collection('YachtCollection').add({
        'images': _imageFiles.map((file) => file.path).toList(),
        'dob': dobController.text,
        'amount': amountController.text,
        'OwnerNumber': OwnerNumberController.text,
        'YachtBrand': YachtBrandController.text,
        'YachtModel': YachtModelController.text,
        'YachtIndividual': YachtIndividualController.text,
        'Yachtspeed': YachtspeedController.text,
        'OwnerName': OwnerNameController.text,
        'description': DescriptionController.text,
        'processed': isChecked,
        'city': locationController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Yacht Added Successfully',
        desc: 'Thank you for adding the yacht.',
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
          "Add Yacht",
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
                    "Add Yacht Images",
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
                if (_imageFiles.length > 1)
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
                if (_imageFiles.isNotEmpty)
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
            "Yacht Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),

          TripsYachtsTextForm(
            hintText: 'ex. Sharm El Sheikh',
            labelText: 'Enter Yacht Location',
            controller: locationController,
            maxLines: 4,
          ),


          TripsYachtsTextForm(
            hintText: 'Yacht description',
            labelText: 'Enter Yacht description in 200 words',
            controller: DescriptionController,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Owner Name',
            labelText: 'Enter Yacht Owner Name',
            controller: OwnerNameController,
            keyboardType: TextInputType.text,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            suffixIcon: Icon(Icons.calendar_month),
            hintText: 'Available Date',
            labelText: 'Available Date of Yacht',
            onTap: () => _selectDate(context, dobController),
            readOnly: true,
            controller: dobController,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Enter Amount',
            labelText: 'Range Amount for Yacht',
            controller: amountController,
            keyboardType: TextInputType.number,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Contact Number',
            labelText: 'Enter Number of Yacht Owner',
            controller: OwnerNumberController,
            keyboardType: TextInputType.number,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Brand',
            labelText: 'Enter Yacht Brand',
            controller: YachtBrandController,
            keyboardType: TextInputType.text,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Model Number',
            labelText: 'Enter Yacht Model no.',
            controller: YachtModelController,
            keyboardType: TextInputType.number,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Speed',
            labelText: 'Enter Yacht Speed in Knots',
            controller: YachtspeedController,
            keyboardType: TextInputType.number,
            maxLines: 4,
          ),
          TripsYachtsTextForm(
            hintText: 'Yacht Capacity',
            labelText: 'Enter Yacht individual Capacity',
            controller: YachtIndividualController,
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
                  'Process will take some time to complete about 1 day to 2 days',
                  softWrap: true,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
          "Submit Yacht Details",
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
