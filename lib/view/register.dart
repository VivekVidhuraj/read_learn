import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen ({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final Color _primaryColor = const Color(0xFF0A0E21);
  final Color _secondaryColor = const Color(0xFFFFA726);

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Handle registration logic
      Navigator.pop(context); // Go back to the previous screen after registration
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: _primaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', _nameController, TextInputType.name),
              const SizedBox(height: 16),
              _buildTextField('Email', _emailController, TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Mobile', _mobileController, TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Password', _passwordController, TextInputType.visiblePassword, obscureText: true),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Register', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (label == 'Mobile' && !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
    );
  }
}
