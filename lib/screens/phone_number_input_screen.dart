import 'package:flutter/material.dart';
import 'package:zippy/screens/home.dart';
import 'package:zippy/screens/phone_number_verification_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  final User user;

  const PhoneNumberInputScreen({Key? key, required this.user}) : super(key: key);

  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final _phoneController = TextEditingController();
  String? _countryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            Row(
              children: [
                CountryCodePicker(
                  onChanged: (countryCode) {
                    _countryCode = countryCode.dialCode;
                  },
                  initialSelection: 'US',
                  favorite: ['+1', 'US'],
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final phoneNumber = '$_countryCode${_phoneController.text}';
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhoneNumberVerificationScreen(phoneNumber: phoneNumber),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
