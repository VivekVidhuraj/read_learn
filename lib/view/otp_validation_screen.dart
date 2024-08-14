
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/view/home_screen.dart';

class OTPValidationScreen extends StatefulWidget {
  final String email;

  const OTPValidationScreen({super.key, required this.email});

  @override
  _OTPValidationScreenState createState() => _OTPValidationScreenState();
}

class _OTPValidationScreenState extends State<OTPValidationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpControllers = List.generate(6, (index) => TextEditingController());
  final _focusNodes = List.generate(6, (index) => FocusNode());

  final Color _primaryColor = const Color(0xFF1E88E5);
  final Color _accentColor = const Color(0xFFFFC107);
  final Color _textColor = const Color(0xFF333333);
  final Color _buttonBackgroundColor = const Color(0xFF1E88E5);
  final Color _cardBackgroundColor = const Color(0xFFF5F5F5);

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _validateOTP() {
    if (_formKey.currentState!.validate()) {
      Get.to(const HomeScreen());
    }
  }

  void _moveFocus(int index) {
    if (index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else {
      _focusNodes[index].unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Read & Learn',
                style: TextStyle(color: _primaryColor),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'asset/images/logo.png', // Replace with your logo asset path
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildCard(
                      'OTP Validation',
                      Column(
                        children: [
                          Text(
                            'An OTP has been sent to ${widget.email}',
                            style: TextStyle(fontSize: 16, color: _primaryColor),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return _buildOTPBox(index);
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _validateOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Validate OTP',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: _cardBackgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 40,
      height: 50,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          counterText: '',
        ),
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            _moveFocus(index);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}
