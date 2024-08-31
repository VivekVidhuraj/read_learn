import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  void _toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    bool isValid = _validateInput(email, password, confirmPassword);

    if (isValid) {
      await _authController.signUp(email, password, confirmPassword);
    } else {
      // Focus on the first field with an error
      if (_emailError != null) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      } else if (_passwordError != null) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      } else if (_confirmPasswordError != null) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      }
    }
  }

  bool _validateInput(String email, String password, String confirmPassword) {
    bool isValid = true;

    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Password cannot be empty';
        isValid = false;
      } else if (!_isPasswordValid(password)) {
        _passwordError = 'Password must be 8-12 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
        isValid = false;
      } else {
        _passwordError = null;
      }

      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Confirm Password cannot be empty';
        isValid = false;
      } else if (password != confirmPassword) {
        _confirmPasswordError = 'Passwords do not match.';
        isValid = false;
      } else {
        _confirmPasswordError = null;
      }

      // Validate email as well
      _emailError = _isEmailValid(email) ? null : 'Please enter a valid email address.';
    });

    return isValid;
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,12}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Email', _emailController, TextInputType.emailAddress, _emailFocusNode, onChanged: _validateEmail),
              const SizedBox(height: 16),
              _buildPasswordField('Password', _passwordController, _passwordFocusNode, onChanged: _validatePassword),
              const SizedBox(height: 16),
              _buildPasswordField('Confirm Password', _confirmPasswordController, _confirmPasswordFocusNode, isConfirmPassword: true, onChanged: _validateConfirmPassword),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0E21),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed('/login');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType inputType, FocusNode focusNode, {void Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        if (onChanged != null) {
          onChanged(controller.text);
        }
        FocusScope.of(context).nextFocus();
      },
      onChanged: (text) {
        if (onChanged != null) {
          onChanged(text);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorText: _emailError, // Only used for email field
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, FocusNode focusNode, {bool isConfirmPassword = false, required void Function(String) onChanged}) {
    return Obx(
          () => TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isConfirmPassword ? _obscureConfirmPassword.value : _obscurePassword.value,
        textInputAction: isConfirmPassword ? TextInputAction.done : TextInputAction.next,
        onEditingComplete: () {
          if (_isPasswordValid(controller.text)) {
            if (!isConfirmPassword) {
              FocusScope.of(context).nextFocus(); // Move to confirm password field
            } else {
              _handleSignUp(); // Final validation and sign-up
            }
          } else {
            _validatePassword(controller.text); // Keep focus on password field if invalid
          }
        },
        onChanged: (text) => onChanged(text),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirmPassword
                  ? _obscureConfirmPassword.value ? Icons.visibility : Icons.visibility_off
                  : _obscurePassword.value ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: isConfirmPassword ? _toggleConfirmPasswordVisibility : _togglePasswordVisibility,
          ),
          errorText: isConfirmPassword ? _confirmPasswordError : _passwordError,
        ),
      ),
    );
  }

  void _validateEmail(String email) {
    setState(() {
      _emailError = _isEmailValid(email) ? null : 'Please enter a valid email address.';
    });
  }

  void _validatePassword(String password) {
    setState(() {
      _passwordError = _isPasswordValid(password)
          ? null
          : 'Password must be 8-12 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
    });
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      _confirmPasswordError = _passwordController.text == confirmPassword ? null : 'Passwords do not match.';
    });
  }
}
