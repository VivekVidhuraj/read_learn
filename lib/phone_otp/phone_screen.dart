import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp_screen.dart';

class Phone_Screen extends StatefulWidget {
  const Phone_Screen({super.key});

  @override
  State<Phone_Screen> createState() => _Phone_ScreenState();
}

class _Phone_ScreenState extends State<Phone_Screen> {
  final phoneController = TextEditingController();
  bool isLoading = false;

  // Function to validate the phone number format
  bool validatePhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Phone Authentication",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.25),
                filled: true,
                hintText: "Enter Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      String phoneNumber = '+91' + phoneController.text.trim();

                      if (validatePhoneNumber(phoneNumber)) {
                        setState(() {
                          isLoading = true;
                        });

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneNumber,
                          verificationCompleted: (phoneAuthCredential) {},
                          verificationFailed: (error) {
                            log(error.toString());
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Verification failed: ${error.message}'),
                              ),
                            );
                          },
                          codeSent: (verificationId, forceResendingToken) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                  verificationId: verificationId,
                                ),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (verificationId) {
                            log("Auto Retrieval timeout");
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Invalid phone number format. Please enter in E.164 format.'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Sign in",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
