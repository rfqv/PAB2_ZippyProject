import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: zippy_screen(),
    );
  }
}

class zippy_screen extends StatelessWidget {
  const zippy_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ZIPPY',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/zippy.png',
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Haayyi...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                ),
                label: const Text('Continue with Google'),
                onPressed: () {
                  // Tambahkan fungsi login dengan Google di sini
                },
              ),
              const SizedBox(height: 10),
              const Text('or'),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Create account'),
                onPressed: () {
                  // Tambahkan fungsi untuk membuat akun di sini
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'By signing up, you agree to our Terms, Privacy Policy and Cookie Use.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
