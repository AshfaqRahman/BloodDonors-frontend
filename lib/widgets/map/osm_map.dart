import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../modals/osm_model.dart';

class OsmInputMapWiddget extends StatefulWidget {
  final double widthFraction;
  final double latitude;
  final double longitude;
  double zoom;
  late OsmInputMap osmMap;

  OsmInputMapWiddget({
    Key? key,
    required this.widthFraction,
    required this.latitude,
    required this.longitude,
    required this.zoom,
  }) : super(key: key);

  @override
  _OsmInputMapWiddgetState createState() => _OsmInputMapWiddgetState();
}

class _OsmInputMapWiddgetState extends State<OsmInputMapWiddget> {
  String? userLocationInput;
  late LatLng _selectedLatLng;
  OsmLocation? _selectedLocation;

  @override
  void initState() {
    _selectedLatLng = LatLng(widget.latitude, widget.longitude);

    widget.osmMap = OsmInputMap(widget.latitude, widget.longitude, widget.zoom,
        (OsmLocation location) {
      double lat = location.latitude;
      double lng = location.longitude;
      String displayName = location.displayName;
      // print("_OsmInputMapWiddgetState: display name : $displayName");
      _selectedLatLng = LatLng(lat, lng);
      _selectedLocation = location;
      stMap?.redraw(_selectedLatLng, 16);
    });

    getOSMAddressFromLatLng(widget.latitude, widget.longitude)
        .then((OsmLocation location) {
      _selectedLocation = location;
    });

    stMap = _getStMap();

    super.initState();
  }

  StMap? stMap;

  StMap _getStMap() {
    return StMap(
      widthFraction: (widget.widthFraction - 0.2),
      osmMap: widget.osmMap,
      selectedLatLng: _selectedLatLng,
      zoom: widget.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print("OsmInputMapWiddget(w: $width, h: $height)");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.where_to_vote, color: Colors.white),
        onPressed: () {
          userLocationInput = "";
          Navigator.pop(context, _selectedLocation);
        },
      ),
      body: Container(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Container(
                width: width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        //initialValue: "Email",
                        cursorColor: Theme.of(context).primaryColor,
                        decoration:
                            _getInputDecoration('Search location', null),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          print("sumbitted value: $value");
                          setState(() {
                            userLocationInput = value;
                            FocusScope.of(context).requestFocus(
                                FocusNode()); // stop the dialog to close
                          });
                        },
                        onSaved: (value) {
                          print("user input: $value");
                        },
                      ),
                    ),
                    if (userLocationInput != null && userLocationInput != "")
                      FutureBuilder(
                          future: searchLocation(userLocationInput ?? ""),
                          builder: (context,
                              AsyncSnapshot<List<OsmLocation>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else {
                              print("ok");
                              //print(snapshot.data);
                              return snapshot.data == null
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : ListView(
                                      shrinkWrap: true,
                                      children: snapshot.data!
                                          .map((OsmLocation item) {
                                        return ListTile(
                                          onTap: () {
                                            widget.zoom = 16;
                                            widget.osmMap.clearMarkers();
                                            _selectedLatLng = LatLng(
                                                item.latitude, item.longitude);
                                            getOSMAddressFromLatLng(
                                                    item.latitude,
                                                    item.longitude)
                                                .then((value) {
                                              _selectedLocation = value;
                                            });
                                            stMap?.redraw(_selectedLatLng, 16);
                                          },
                                          leading: _iconFromType(item.type??""),
                                          title: Text(item.displayName),
                                          subtitle: Text(
                                              "${item.latitude}, ${item.longitude}"),
                                        );
                                      }).toList(),
                                    );
                            }
                          }),
                  ],
                ),
              ),
            ),
          ),
          stMap!,
        ]),
      ),
    );
  }

  Widget _iconFromType(String type) {
    switch (type) {
      case "city":
        return Icon(FontAwesomeIcons.city);
      case "administrative":
        return Icon(FontAwesomeIcons.mapMarkedAlt);
      case "village":
        return Icon(Icons.maps_home_work_outlined);
      case "place_of_worship":
        return Icon(FontAwesomeIcons.placeOfWorship);
      case "residential":
        return Icon(Icons.home_work_outlined);
      case "healt":
      case "hospital":
        return Icon(FontAwesomeIcons.hospital);
      case "college":
        return Icon(Icons.school);
      case "industrial":
        return Icon(FontAwesomeIcons.industry);
      default:
        return Icon(FontAwesomeIcons.landmark);
    }
  }

  InputDecoration _getInputDecoration(String labelText, IconButton? icon) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: Theme.of(context).textTheme.subtitle2?.fontSize,
      ),
      //errorText: 'Please insert a valid email',
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      suffixIcon: icon,
    );
  }
}

class StMap extends StatefulWidget {
  StMap({
    Key? key,
    required this.widthFraction,
    required this.osmMap,
    required LatLng selectedLatLng,
    required this.zoom,
  })  : _selectedLatLng = selectedLatLng,
        super(key: key);

  final double widthFraction;
  final OsmInputMap osmMap;
  LatLng _selectedLatLng;
  double zoom;

  void redraw(LatLng at, double zoom) {
    temp.setState(() {
      _selectedLatLng = at;
      this.zoom = zoom;
    });
  }

  late _StMapState temp;

  @override
  State<StMap> createState() {
    temp = _StMapState();
    return temp;
  }
}

class _StMapState extends State<StMap> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.red,
      width: widget.widthFraction * width,
      child: widget.osmMap.getFlutterMap(widget._selectedLatLng.latitude,
          widget._selectedLatLng.longitude, widget.zoom),
    );
  }
}

// https://pub.dev/packages/flutter_map
// https://medium.com/zipper-studios/flutter-map-custom-and-dynamic-popup-over-the-marker-732d26ef9bc7
class OsmInputMap {
  double lat;
  double lng;
  double zoom;
  List<Marker> _markers = [];
  Function _onMapClicked;
  late MapController _mapController;

  OsmInputMap(this.lat, this.lng, this.zoom, this._onMapClicked) {
    _markers.add(makeMarker(lat, lng));
    _mapController = MapController();
  }

  FlutterMap getMap() {
    return getFlutterMap(lat, lng, zoom);
  }

  Marker makeMarker(double lat, double lng) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lng),
      builder: (ctx) => Container(
        child: const Icon(
          FontAwesomeIcons.mapMarkerAlt,
          size: 36,
          color: Colors.red,
        ),
      ),
    );
  }

  void clearMarkers() {
    _markers.clear();
  }

  // https://pub.dev/packages/flutter_map
  // https://medium.com/zipper-studios/flutter-map-custom-and-dynamic-popup-over-the-marker-732d26ef9bc7
  // https://stackoverflow.com/questions/61155942/flutter-map-move-camera-with-map-controller-through-bloc
  FlutterMap getFlutterMap(lat, lng, z) {
    // print("getFlutterMap(): drawing map at $lat, $lng, zoom: $z");
    _markers.clear();
    _markers.add(makeMarker(lat, lng));
    _mapController.onReady
        .then((value) => {_mapController.move(LatLng(lat, lng), z)});
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(lat, lng),
        zoom: z,
        onTap: (tapPosition, point) {
          this.lat = point.latitude;
          this.lng = point.longitude;
          print(
              "getFlutterMap(): clicked: ${point.latitude} ${point.longitude}");
          getOSMAddressFromLatLng(point.latitude, point.longitude)
              .then((OsmLocation location) {
            print("address: $location");

            /*  _markers.clear();
            _markers.add(makeMarker(point.latitude, point.longitude)); */

            _onMapClicked(location);
          });
        },
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: _markers,
        ),
      ],
    );
  }
}

// https://nominatim.org/release-docs/develop/api/Reverse/
Future<OsmLocation> getOSMAddressFromLatLng(double lat, double lng) async {
  String _host = 'https://nominatim.openstreetmap.org/reverse';
  //final url = '$_host?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1';
  final url = '$_host?format=jsonv2&lat=$lat&lon=$lng&zoom=18&addressdetails=1';
  if (lat != null && lng != null) {
    Response response = await Dio().get(url);
    if (response.statusCode == 200) {
      Map data = response.data;
      //print(data);
      return OsmLocation(
          latitude: lat,
          longitude: lng,
          displayName: data["display_name"] ?? "unknown",
          type: data["type"] ?? "unknown");
      ;
    } else {
      return OsmLocation(
          latitude: lat,
          longitude: lng,
          displayName: "unknown",
          type: "unknown");
    }
  } else {
    return OsmLocation(
        latitude: lat, longitude: lng, displayName: "unknown", type: "unknown");
    ;
  }
}

// https://nominatim.org/release-docs/develop/api/Reverse/
Future<List<OsmLocation>> searchLocation(String location) async {
  String url =
      'https://nominatim.openstreetmap.org/search?format=json&q=$location';
  Response response = await Dio().get(url);
  if (response.statusCode == 200) {
    List data = response.data;
    print("search result for location $location");
    //print(data);

    List<OsmLocation> result = data.map((item) {
      // print("item");
      // print("location = ${item['lat']} , ${item['lon']}, ${item['display_name']}");
      OsmLocation l = OsmLocation(
          latitude: double.parse(item['lat']),
          longitude: double.parse(item['lon']),
          displayName: item['display_name'],
          type: item['type'] ?? "");
      //print("location created");
      print(l);
      return l;
    }).toList();

    print("total location: ${result.length}");

    //String _formattedAddress = data["display_name"];
    //print("response ==== $_formattedAddress");
    return result;
  } else {
    return [];
  }
}
