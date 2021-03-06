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
      'display_name': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Location fromMap(Map map) {
    return Location(
        description: map['display_name'],
        latitude: map['latitude'],
        longitude: map['longitude']);
  }
}
