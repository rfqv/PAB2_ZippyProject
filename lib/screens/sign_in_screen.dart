import 'package:flutter/material.dart';
import 'package:zippy/navigator/app_navigator.dart'; // Import MyBottomNavbar
import 'package:zippy/screens/sign_up_screen.dart';
import 'package:zippy/screens/lupa_password.dart'; // Import LupaPasswordScreen
import 'package:zippy/services/sign_in_services.dart'; // Import SignInService

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, Key? Key});
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  String _errorMessage = '';
  bool _isCaptchaCorrect = false;
  String _generatedCaptcha = '';
  bool _isPasswordHidden = true;

  // Buat instance dari SignInService
  final SignInService _signInService = SignInService();

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
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

  void _togglePasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty && password.isEmpty) {
      _showErrorDialog('Email dan Password tidak boleh kosong. Silahkan di isi terlebih dahulu!');
    } else if (email.isNotEmpty && password.isEmpty) {
      _showErrorDialog('Password tidak boleh kosong. Silahkan di isi terlebih dahulu!');
    } else if (email.isEmpty && password.isNotEmpty) {
      _showErrorDialog('Email tidak boleh kosong. Silahkan di isi terlebih dahulu!');
    } else {
      try {
        // Panggil metode signInWithEmailAndPassword dari SignInService
        final user = await _signInService.signInWithEmailAndPassword(email, password);

        if (user != null) {
          // Jika berhasil sign in, navigasi ke MyBottomNavbar
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyBottomNavbar()),
          );
        } else {
          // Tampilkan pesan error jika sign in gagal
          setState(() {
            _errorMessage = 'Failed to sign in. Please check your credentials.';
          });
        }
      } catch (error) {
        // Tangani error
        String errorMessage = 'An error occurred during sign in!';
        setState(() {
          _errorMessage = errorMessage;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = brightness == Brightness.dark ? Colors.black : Colors.white;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
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
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _togglePasswordView,
                  ),
                ),
              ),
              const SizedBox(height: 1.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LupaPasswordScreen()),
                    );
                  },
                  child: const Text('Lupa password?'),
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
              const SizedBox(height: 8.0),
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
                onPressed: _isCaptchaCorrect ? _handleSignIn : null,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final user = await _signInService.signInWithGoogle();

                    if (user != null) {
                      // Jika berhasil sign in via Google, navigasi ke MyBottomNavbar
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyBottomNavbar()),
                      );
                    } else {
                      // Tampilkan pesan error jika sign in via Google gagal
                      setState(() {
                        _errorMessage = 'Failed to sign in with Google.';
                      });
                    }
                  } catch (error) {
                    // Tangani error
                    String errorMessage = 'An error occurred during Google sign in!';
                    setState(() {
                      _errorMessage = errorMessage;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
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
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Sign up'),
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
