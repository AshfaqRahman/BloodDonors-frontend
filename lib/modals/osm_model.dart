class OsmLocation {
  OsmLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.displayName,
    this.type
  });

  String? id;
  double latitude;
  double longitude;
  String displayName;
  String? type;

  OsmLocation.fromOsm({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });

  factory OsmLocation.fromJson(Map<String, dynamic> json) {
    return OsmLocation(
      id: json["id"],
      latitude: json["latitude"].toDouble(),
      longitude: json["longitude"].toDouble(),
      displayName: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "latitude": latitude,
      "longitude": longitude,
      "description": displayName,
    };
  }

  @override
  String toString() {
    return "OsmLocation($latitude, $longitude, $type, $displayName)";
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'displayName': displayName,
    };
  }
}
