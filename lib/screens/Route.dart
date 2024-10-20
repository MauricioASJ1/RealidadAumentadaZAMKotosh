import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' hide LatLng;

void main() => runApp(const Route());

class Route extends StatelessWidget {
  const Route({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Map(),
    );
  }
}

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  MapState createState() => MapState();
}

class MapState extends State<Map> {
  late GoogleMapController mapController;
  late bool withinPolygon = true;
  LatLng initialCameraPosition =
      const LatLng(36.15633180705401, -95.99487937064549);
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    LatLng currentLocation = await _determinePosition();
    setState(() {
      initialCameraPosition = currentLocation;
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      withinPolygon = value;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    location.onLocationChanged.listen((youAreHere) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(youAreHere.latitude!, youAreHere.longitude!),
        zoom: 18.0,
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            mapType: MapType.terrain,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: markers,
            polygons: polygons,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: initialCameraPosition,
              zoom: 18.0,
            ),
          ),
        ),
        if (withinPolygon)
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, "/ObjectsOnPlanesWidget");
              },
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                  child: Image.asset(
                    'assets/images/custom_icon.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }
}
