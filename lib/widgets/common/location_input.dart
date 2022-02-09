import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../modals/osm_model.dart';
import '../../utils/location.dart';
import '../map/osm_map.dart';

class InputLocation extends StatefulWidget {
  final Function onLocationSelected;
  const InputLocation({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _InputLocationState createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  OsmLocation? selectedLocation;
  bool _foundLocation = false;

  void _openMapDialog(double lat, double lng, double zoom) async {
    // print("inside _openMapDialog");
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    OsmLocation location = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: width * 0.7,
              height: height * 0.8,
              child: OsmInputMapWiddget(
                widthFraction: 0.7,
                latitude: lat,
                longitude: lng,
                zoom: zoom,
              ),
            ),
          );
        });
    // print("location found: $location");

    setState(() {
      widget.onLocationSelected(location);
      _foundLocation = true;
      selectedLocation = location;
    });
  }

  void showMapDialog() {
    // print("inside showMapDialog");
    determinePosition().then((Position position) async {
      double lat = position.latitude;
      double lng = position.longitude;
      // print("showMapDialog: userlocation($lat, $lng)");
      _openMapDialog(lat, lng, 16);
    }).onError((error, stackTrace) {
      print("Error getting user location! Error: $error");
      _openMapDialog(23.8175925, 90.21930545737357, 1.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => showMapDialog(),
          child: Text('select your location'),
        ),
        if (_foundLocation)
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Selected address: ${selectedLocation?.displayName}"),
          ),
      ],
    );
  }
}