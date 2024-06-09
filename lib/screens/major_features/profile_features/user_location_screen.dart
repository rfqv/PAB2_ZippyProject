import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  late GoogleMapController mapController;
  LatLng? _initialLocation;
  LatLng? _selectedLocation;
  Position? _currentPosition;
  String? _username;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUserLocation();
    _getCurrentLocation();
  }

  Future<void> _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = _dbRef.child('users').child(user.uid).child('username');
      final snapshot = await ref.get();
      if (snapshot.exists) {
        setState(() {
          _username = snapshot.value as String;
        });
      }
    }
  }

  Future<void> _fetchUserLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = _dbRef.child('users').child(user.uid).child('userLocation');
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final latitude = data['latitude'] as double;
        final longitude = data['longitude'] as double;
        setState(() {
          _initialLocation = LatLng(latitude, longitude);
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        setState(() {
          _currentPosition = position;
          _initialLocation = LatLng(position.latitude, position.longitude);
        });
      } catch (e) {
        print('Error getting location: $e');
      }
    } else {
      print('Location permission denied');
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedLocation != null) {
      final ref = _dbRef.child('users').child(user.uid).child('userLocation');
      await ref.set({
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
        title: Text('@' '$_username\'s Location' ?? 'Loading...'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _initialLocation != null
                ? GoogleMap(
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
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          if (_currentPosition != null) 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
