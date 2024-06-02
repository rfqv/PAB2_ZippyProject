import 'package:flutter/material.dart';
import 'package:zippy/screens/email_verification_screen.dart';
import 'package:zippy/services/sign_up_services.dart';
import 'package:zippy/screens/sign_in_screen.dart'; // Import SignInScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  // Buat instance dari SignUpService
  final SignUpService _signUpService = SignUpService();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = brightness == Brightness.dark ? Colors.black : Colors.white;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    final user = await _signUpService.signUpWithEmailAndPassword(email, password);

                    if (user != null) {
                      await user.sendEmailVerification();
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
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
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
                // style: ElevatedButton.styleFrom(
                  // backgroundColor: backgroundColor,
                  // foregroundColor: textColor, 
                // ),
              ),
              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                  );
                },
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
