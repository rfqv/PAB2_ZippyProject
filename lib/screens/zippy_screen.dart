import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: zippy_screen(),
    );
  }
}

class zippy_screen extends StatelessWidget {
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
              Text(
                'ZIPPY',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/zippy.png',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Haayyi...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                ),
                label: Text('Continue with Google'),
                onPressed: () {
                  // Tambahkan fungsi login dengan Google di sini
                },
              ),
              SizedBox(height: 10),
              Text('or'),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Create account'),
                onPressed: () {
                  // Tambahkan fungsi untuk membuat akun di sini
                },
              ),
              SizedBox(height: 20),
              Text(
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
