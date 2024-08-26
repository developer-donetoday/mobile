import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class NeighborhoodScreen extends StatefulWidget {
  @override
  _NeighborhoodScreenState createState() => _NeighborhoodScreenState();
}

class _NeighborhoodScreenState extends State<NeighborhoodScreen> {
  String _mapStyle = '';

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  void _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    setState(() {
      _mapStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              // Add your Google Maps configuration here
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194), // San Francisco coordinates
                zoom: 12,
              ),
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.setMapStyle(_mapStyle);
              }),
        ],
      ),
    );
  }
}
