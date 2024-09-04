import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;
  final RxBool _rememberMe = false.obs;

  String? _emailError;
  String? _passwordError;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final savedCredentials = await _authController.getSavedCredentials();
    if (savedCredentials != null) {
      _emailController.text = savedCredentials['email']!;
      _passwordController.text = savedCredentials['password']!;
      _rememberMe.value = true;
    }
  }

  void _togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool isValid = _validateInput(email, password);

    if (isValid) {
      final result = await _authController.login(email, password, rememberMe: _rememberMe.value);

      if (result != null) {
        Get.offAllNamed('/home');
        // Get.snackbar('Success', 'Login successful',
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.green,
        //     colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } else {
      if (_emailError != null) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      } else if (_passwordError != null) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    }
  }

  bool _validateInput(String email, String password) {
    bool isValid = true;

    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email cannot be empty';
        isValid = false;
      } else if (!_isEmailValid(email)) {
        _emailError = 'Please enter a valid email address.';
        isValid = false;
      } else {
        _emailError = null;
      }

      if (password.isEmpty) {
        _passwordError = 'Password cannot be empty';
        isValid = false;
      } else if (!_isPasswordValid(password)) {
        _passwordError = 'Password must be 8-12 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
        isValid = false;
      } else {
        _passwordError = null;
      }
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

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      _authController.resetPassword(email);
    } else {
      Get.snackbar('Error', 'Please enter your email to reset password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
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
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Email',
                _emailController,
                TextInputType.emailAddress,
                _emailFocusNode,
                onChanged: _validateEmail,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                'Password',
                _passwordController,
                _passwordFocusNode,
                onChanged: _validatePassword,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                        () => Row(
                      children: [
                        Checkbox(
                          value: _rememberMe.value,
                          onChanged: (value) {
                            _rememberMe.value = value ?? false;
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _handleForgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/register');
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType, FocusNode focusNode, {required void Function(String) onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        onChanged(controller.text);
        FocusScope.of(context).nextFocus();
      },
      onChanged: (text) => onChanged(text),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        errorText: _emailError, // Only used for email field
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, FocusNode focusNode, {required void Function(String) onChanged}) {
    return Obx(
          () => TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: _obscurePassword.value,
        textInputAction: TextInputAction.done,
        onEditingComplete: () {
          if (_isPasswordValid(controller.text)) {
            _handleLogin();
          } else {
            _validatePassword(controller.text);
          }
        },
        onChanged: (text) => onChanged(text),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword.value ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: _togglePasswordVisibility,
          ),
          errorText: _passwordError, // Only used for password field
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
}
