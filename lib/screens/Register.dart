import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../components/colors.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmPasswordController =
      TextEditingController();
  final TextEditingController NameController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> SignUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = ConfirmPasswordController.text.trim();
    String name = NameController.text.trim();
    String phone = PhoneController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Please fill all fields',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    if (password != confirmPassword) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Passwords do not match',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent user from closing the dialog manually
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Creating account..."),
            ],
          ),
        );
      },
    );

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        String address = "${position.latitude}, ${position.longitude}";

        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;
        if (user != null) {
          await user.sendEmailVerification();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': email,
            'name': name,
            'phone': phone,
            'address': address,
            'isEmailVerified': false,
          });

          await _auth.signOut();

          // Dismiss the loading dialog
          Navigator.pop(context);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            title: 'Success',
            desc:
                'Account created successfully. Please verify your email before logging in.',
            btnOkOnPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ).show();
        }
      } else {
        // Dismiss loading dialog
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Error',
          desc: 'Location permission denied',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      // Dismiss loading dialog
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.4,
              width: size.width,
              decoration: BoxDecoration(
                gradient: AppColors.SeaGradient,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(100)),
              ),
              child: Image.asset('assets/images/y2.png'),
            ),
            SizedBox(height: size.height * 0.02),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: NameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(179, 100, 100, 100),
                        ),
                        contentPadding: EdgeInsets.only(left: 16.0, top: 13.5),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.message,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(179, 100, 100, 100),
                        ),
                        contentPadding: EdgeInsets.only(left: 16.0, top: 11),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: PhoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                        hintText: 'Phone',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(179, 100, 100, 100),
                        ),
                        contentPadding: EdgeInsets.only(left: 16.0, top: 11),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.key,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(179, 100, 100, 100),
                        ),
                        contentPadding: EdgeInsets.only(left: 16.0, top: 11),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: ConfirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.key_off,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(179, 100, 100, 100),
                        ),
                        contentPadding: EdgeInsets.only(left: 16.0, top: 11),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: SignUp,
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            spreadRadius: 0,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 59, 160, 151),
                            Color.fromARGB(174, 7, 156, 144)
                          ],
                          end: Alignment.bottomCenter,
                          begin: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: 20), // Add some space before the text at the bottom
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 59, 160, 151)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
