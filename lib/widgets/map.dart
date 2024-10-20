import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' hide LatLng;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() => runApp(const MapApp());

class MapApp extends StatelessWidget {
  const MapApp({Key? key}) : super(key: key);

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
  bool showBackButton = false;
  bool showExtraImage = false; // New state to show extra image
  bool isTracking = true;
  LatLng initialCameraPosition =
      const LatLng(-9.93096391111473, -76.27954739104109);
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};
  Set<Polyline> polylines = {};
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

    if (isTracking) {
      location.onLocationChanged.listen((youAreHere) {
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(youAreHere.latitude!, youAreHere.longitude!),
          zoom: 18.0,
        )));
      });
    }
  }

  void toggleSwitch(bool value) {
    setState(() {
      withinPolygon = value;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setInitialLocation(); // Set initial location
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
            polylines: polylines,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: initialCameraPosition,
              zoom: 18.0,
            ),
          ),
        ),
        if (withinPolygon && !showBackButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: _showRoute,
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
        if (showBackButton)
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: _onBackButtonPressed,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        if (showExtraImage) // Show additional image
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/ObjectsOnPlanesWidget');
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                      0.5), // Black background with 50% transparency
                  borderRadius:
                      BorderRadius.circular(10), // Optional: rounded corners
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/custom_RA.png', // Replace with your image path
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showRoute() async {
    LatLng destination = LatLng(-9.930800096643953, -76.27942133108549);
    LatLng origin = initialCameraPosition;

    // Move the camera to the destination location and stop tracking location updates
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: destination,
      zoom: 18.0,
    )));
    setState(() {
      polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: [origin, destination],
        color: Colors.blue,
        width: 5,
      ));
      withinPolygon = false; // Hide the custom icon after showing the route
      showBackButton = true; // Show the back button
      showExtraImage = true; // Show the additional image
      isTracking = false; // Stop tracking location updates
    });
  }

  Future<void> _onBackButtonPressed() async {
    setState(() {
      // Reset the state to show the custom icon and hide the back button
      withinPolygon = true;
      showBackButton = false;
      showExtraImage = false; // Hide the additional image
      polylines.clear(); // Optional: Clear existing routes
      isTracking = true; // Re-enable location tracking
      _setInitialLocation(); // Reset location updates
    });
  }

  Future<List<LatLng>> _getRoutePoints(
      LatLng origin, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    String googleApiKey = 'AIzaSyDE3eBhGKWwMHdGpOtM00EM7eAP_p6SkOo';

    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(origin.latitude, origin.longitude),
      destination: PointLatLng(destination.latitude, destination.longitude),
      mode: TravelMode.driving, // Puedes cambiar el modo según tus necesidades
    );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
      googleApiKey: googleApiKey,
    );

    if (result.points.isNotEmpty) {
      return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
    } else {
      return [];
    }
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
