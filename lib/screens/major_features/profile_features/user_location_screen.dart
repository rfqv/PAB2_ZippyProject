import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zippy/screens/main_session/profile.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  late GoogleMapController mapController;
  LatLng? _initialLocation;
  LatLng? _selectedLocation;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('userLocation');

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final latitude = data['latitude'] as double;
      final longitude = data['longitude'] as double;
      setState(() {
        _initialLocation = LatLng(latitude, longitude);
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_initialLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(_initialLocation!),
      );
    }
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _saveLocation() async {
    if (_selectedLocation != null) {
      await _dbRef.set({
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location saved successfully')),
      );
    }
  }

  Future<void> _openGoogleMaps() async {
    if (_initialLocation != null) {
      final url = 'https://www.google.com/maps/search/?api=1&query=${_initialLocation!.latitude},${_initialLocation!.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _showOpenMapsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buka Google Maps?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openGoogleMaps();
            },
            child: const Text('Iya'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'),
      ),
      body: Column(
        children: [
          _initialLocation != null
              ? SizedBox(
                  height: 400,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _initialLocation!,
                      zoom: 12.0,
                    ),
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selectedLocation'),
                              position: _selectedLocation!,
                            ),
                          }
                        : {
                            Marker(
                              markerId: const MarkerId('initialLocation'),
                              position: _initialLocation!,
                            ),
                          },
                    onTap: _onMapTap,
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _selectedLocation != null ? _saveLocation : null,
                child: const Text('Simpan Lokasi'),
              ),
              ElevatedButton(
                onPressed: _showOpenMapsDialog,
                child: const Text('Lihat di Maps'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
