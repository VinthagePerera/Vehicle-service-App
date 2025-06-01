import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;
  late String currentLocationText = '';

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            readOnly: true,
            controller: TextEditingController(text: currentLocationText),
            decoration: const InputDecoration(
              labelText: 'Current Location',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          setState(() {
            currentLocationText = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
          });

          googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

          markers.clear();
          markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(position.latitude, position.longitude)));
          setState(() {});

          saveLocationToFirestore(position);
        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  void saveLocationToFirestore(Position position) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  User? user = auth.currentUser;

  if (user != null) {
    GeoPoint userLocation = GeoPoint(position.latitude, position.longitude);

    firestore
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        DocumentReference userRef = docSnapshot.reference;

        userRef.update({
          'location': userLocation,
        }).then((_) {
          print('User location updated successfully');
        }).catchError((error) {
          print('Failed to update user location: $error');
        });
      } else {
        print('User document not found');
      }
    }).catchError((error) {
      print('Error querying user document: $error');
    });
  } else {
    print('Current user is null');
  }
}


}
