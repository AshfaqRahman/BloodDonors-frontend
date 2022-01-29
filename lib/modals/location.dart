import 'package:bms_project/widgets/location_map.dart';

class Location {
  String description;
  double latitude;
  double longitude;

  Location({
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
