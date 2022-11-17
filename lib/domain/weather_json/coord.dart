class Coords {
  double? lon;
  double? lat;

  Coords({this.lon, this.lat});

  Coords.fromJson(Map<String, dynamic> json) {
    lon = json['coord']['lon'] ?? 0;
    lat = json['coord']['lat'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}
