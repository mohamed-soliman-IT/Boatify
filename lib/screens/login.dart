import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/Bottomnav.dart';
import '../components/colors.dart';
import 'Register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for Email & Password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Login Function
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Please enter email and password',
        btnOkOnPress: () {},
      ).show();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Please enter email and password")),
      // );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Success: Navigate to BottomNav page
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          title: 'Login Successful',
          desc: 'Welcome in Boatify',
          btnOkOnPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          },
        ).show();
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Login failed: ${e.toString()}")),
      // );
      // You could also show an error dialog here, if preferred
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Login Failed',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Password reset email sent',
        btnOkOnPress: () {},
      ).show();
    } on FirebaseAuthException catch (err) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: err.message ?? 'An error occurred',
        btnOkOnPress: () {},
      ).show();
    } catch (err) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: err.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Image
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: AppColors.SeaGradient,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                  child: Image.asset('assets/images/Yacht1.png'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                // Email Input
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: _boxDecoration(),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(Icons.email, 'Email'),
                    ),
                  ),
                ),

                // Password Input
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.infinity,
                    decoration: _boxDecoration(),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: _inputDecoration(Icons.lock, 'Password'),
                    ),
                  ),
                ),

                // Forgot Password Text
                GestureDetector(
                  onTap: () {
                    forgotPassword(email: emailController.text.trim());
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                // Login Button
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuthCubit>().signIn(
                            emailController.text,
                            passwordController.text,
                          );
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: _buttonDecoration(),
                      child: state is AuthLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Center(
                              child: Text(
                                'LOGIN',
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

                // Register Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: Color.fromARGB(255, 59, 160, 151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Common BoxDecoration for Inputs
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
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
    );
  }

  // Common InputDecoration for TextFields
  InputDecoration _inputDecoration(IconData icon, String hintText) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black45),
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: TextStyle(color: Color.fromARGB(179, 100, 100, 100)),
      contentPadding: EdgeInsets.only(left: 16.0, top: 11),
      fillColor: Colors.white,
    );
  }

  // Button Decoration
  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 2),
          blurRadius: 5,
          spreadRadius: 0,
        ),
      ],
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 59, 160, 151),
          Color.fromARGB(174, 7, 156, 144),
        ],
        end: Alignment.bottomCenter,
        begin: Alignment.topCenter,
      ),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
