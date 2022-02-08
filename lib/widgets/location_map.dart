import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({Key? key}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};
  bool flag = false;
  var selectedLocation;

  void _setMarker(LatLng pos) {
    setState(() {
      selectedLocation = pos;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(pos.toString()),
          position: pos,
        ),
      );
    });
  }

  late LatLng your_location;
  late BuildContext ctx;

  @override
  @protected
  @mustCallSuper
  void initState() {
    getMap().then((value) {
      setState(() {
        your_location = value;
        flag = true;
      });
      _setMarker(value);
    });
  }

  Future<LatLng> getMap() async {
    // print(your_location);
    // print(flag);
    // if (flag)
    //   return your_location;
    // else {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Navigator.pop(ctx);
        return const LatLng(0, 0);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Navigator.pop(ctx);
        return const LatLng(0, 0);
      }
    }

    _locationData = await location.getLocation();
    // your_location = _locationData;

    var position = LatLng(
      double.parse(_locationData.latitude.toString()),
      double.parse(_locationData.longitude.toString()),
    );

    print(_locationData);
    // _kGooglePlex.target = LatLng(, longitude);
    CameraPosition _kGooglePlex = CameraPosition(
      target: position,
      zoom: 14.4746,
    );

    return position;
  }

  @override
  Widget build(BuildContext context) {
    // getMap(context).then
    ctx = context;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
        child: flag
            ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: your_location,
                  zoom: 15,
                ),
                onMapCreated: (GoogleMapController controller) {
                  // print("in map creation");
                  _controller.complete(controller);
                  // print(your_location);
                  // var position = LatLng(
                  //   your_location.latitude,
                  //   your_location.longitude,
                  // );
                },
                // myLocationEnabled: true,
                // myLocationButtonEnabled: true,
                markers: _markers,
                onTap: (tappedLocation) {
                  _setMarker(tappedLocation);
                },
              )
            : const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              ),
        //     GoogleMap(
        //   mapType: MapType.hybrid,
        //   initialCameraPosition: CameraPosition(
        //     target: LatLng(37.42796133580664, -122.085749655962),
        //     zoom: 14.4746,
        //   ),
        //   onMapCreated: (GoogleMapController controller) {
        //     _controller.complete(controller);
        //   },
        // ),
        //       );
        //   myLocationEnabled: true,
        //   myLocationButtonEnabled: true,
        //   markers: _markers,
        //   onTap: (tappedLocation) {
        //     _setMarker(tappedLocation);
        //   },
        // );
        // child: FutureBuilder<CameraPosition>(
        //   future: getMap(context),
        //   builder: (context, AsyncSnapshot<CameraPosition> snapshot) {
        //     if (snapshot.hasData) {
        //       setState(() {
        //         flag = true;
        //         your_location = snapshot.data!.target;
        //         selectedLocation = your_location;
        //       });
        //       _setMarker(snapshot.data!.target);
        //       CameraPosition k = CameraPosition(
        //         target: snapshot.data!.target,
        //         zoom: 15,
        //       );
        //       // return CircularProgressIndicator();
        //       return GoogleMap(
        //         mapType: MapType.normal,
        //         initialCameraPosition: k,
        //         onMapCreated: (GoogleMapController controller) {
        //           _controller.complete(controller);
        //           // var position = LatLng(
        //           //   your_location.latitude,
        //           //   your_location.longitude,
        //           // );
        //         },
        //         myLocationEnabled: true,
        //         myLocationButtonEnabled: true,
        //         markers: _markers,
        //         onTap: (tappedLocation) {
        //           _setMarker(tappedLocation);
        //         },
        //       );
        //     } else {
        //       return const Center(
        //         child: SizedBox(
        //           child: CircularProgressIndicator(),
        //         ),
        //       );
        //     }
        //     ;
        //   },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.where_to_vote, color: Colors.white),
        onPressed: () {
          // print(_controller.isCompleted);
          Navigator.pop(context, selectedLocation);
          // print("after popping");
          //return;
        },
      ),
    );
  }
}
