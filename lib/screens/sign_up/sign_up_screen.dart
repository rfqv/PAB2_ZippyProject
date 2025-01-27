import 'package:flutter/material.dart';
import 'package:zippy/screens/major_features/sign_up_features/email_verification_screen.dart';
import 'package:zippy/services/sign_up_services.dart';
import 'package:zippy/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _profileNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isCaptchaCorrect = false;
  bool _isUsernameAvailable = true;
  String _errorMessage = '';
  String _usernameMessage = '';
  String _generatedCaptcha = '';

  final SignUpService _signUpService = SignUpService();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _togglePasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
  }

  Future<void> _checkUsernameAvailability() async {
    final username = _usernameController.text;
    final snapshot = await _dbRef
        .child('users')
        .orderByChild('username')
        .equalTo(username)
        .get();
    if (snapshot.exists) {
      setState(() {
        _isUsernameAvailable = false;
        _usernameMessage = 'Username sudah ada. Coba lagi!';
      });
    } else {
      setState(() {
        _isUsernameAvailable = true;
        _usernameMessage = 'Username tersedia!';
      });
    }
  }

  void _generateCaptcha() {
    setState(() {
      _generatedCaptcha = (1000 + (10000 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt().toString();
    });
  }

  void _verifyCaptcha() {
    setState(() {
      _isCaptchaCorrect = _captchaController.text == _generatedCaptcha;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = brightness == Brightness.dark ? Colors.black : Colors.white;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final buttonColor = brightness == Brightness.dark ? Colors.grey[800] : const Color(0xFF7DABCF);
    final buttonTextColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _profileNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nama Pengguna',
                  border: const OutlineInputBorder(),
                  suffixIcon: _isUsernameAvailable
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
                ),
                onChanged: (value) {
                  _checkUsernameAvailability();
                },
              ),
              Text(
                _usernameMessage,
                style: TextStyle(color: _isUsernameAvailable ? Colors.green : Colors.red),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _togglePasswordView,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isConfirmPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Ulangi Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _toggleConfirmPasswordView,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Captcha: $_generatedCaptcha',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _generateCaptcha,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _captchaController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Captcha',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _verifyCaptcha();
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                ),
                onPressed: _isCaptchaCorrect ? () async {
                  if (_passwordController.text != _confirmPasswordController.text) {
                    setState(() {
                      _errorMessage = 'Password dan ulangi password tidak cocok.';
                    });
                    return;
                  }
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final profileName = _profileNameController.text;
                    final username = _usernameController.text;

                    final user = await _signUpService.signUpWithEmailAndPassword(email, password);

                    if (user != null) {
                      await user.sendEmailVerification();
                      await _dbRef.child('users').child(user.uid).set({
                        'email': email,
                        'profileName': profileName,
                        'username': username,
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                EmailVerificationScreen(user: user)),
                      );
                    } else {
                      setState(() {
                        _errorMessage = 'Failed to sign up. Please check your information.';
                      });
                    }
                  } catch (error) {
                    setState(() {
                      _errorMessage = error.toString();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorMessage),
                      ),
                    );
                  }
                } : null,
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: buttonTextColor,
                ),
                onPressed: () async {
                  try {
                    final user = await _signUpService.signUpWithGoogle();

                    if (user != null) {
                      await user.sendEmailVerification();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                EmailVerificationScreen(user: user)),
                      );
                    } else {
                      setState(() {
                        _errorMessage = 'Failed to sign up with Google.';
                      });
                    }
                  } catch (error) {
                    setState(() {
                      _errorMessage = error.toString();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_errorMessage),
                      ),
                    );
                  }
                },
                icon: Image.asset(
                  'assets/app/signin/icons/google_logo.png', // Path to your Google logo asset
                  height: 24.0,
                  width: 24.0,
                ),
                label: const Text('Continue with Google'),
              ),
              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: buttonTextColor,
                ),
                child: const Text('Already have an account? Sign in'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
