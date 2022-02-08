class OsmLocation {
  final double latitude;
  final double longitude;
  final String displayName;
  final String type;

  OsmLocation(
      {required this.latitude,
      required this.longitude,
      required this.displayName, 
      required this.type});

  @override
  String toString() {
    return "OsmLocation($latitude, $longitude, $type, $displayName)";
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'displayName': displayName,
      'icon' : type,
    };
  }
}
