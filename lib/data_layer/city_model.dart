import 'package:equatable/equatable.dart';

class CityDataModel extends Equatable {
  List<Cities>? cities;

  CityDataModel({this.cities});

  CityDataModel.fromJson(Map<String, dynamic> json) {
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(Cities.fromJson(v));
      });
    }
  }
  @override
  List<Object?> get props => [cities];
}

class Cities extends Equatable {
  String? name;
  double? lat;
  double? lng;

  Cities({this.name, this.lat, this.lng});

  Cities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
  }
  @override
  List<Object?> get props => [name, lat, lng];
}

Map<String, dynamic> cityJson = {
  "cities": [
    {"name": "Mumbai", "lat": 19.0760, "lng": 72.8777},
    {"name": "Delhi", "lat": 28.6139, "lng": 77.2090},
    {"name": "Bangalore", "lat": 12.9716, "lng": 77.5946},
    {"name": "Hyderabad", "lat": 17.3850, "lng": 78.4867},
    {"name": "Chennai", "lat": 13.0827, "lng": 80.2707},
    {"name": "Kolkata", "lat": 22.5726, "lng": 88.3639},
    {"name": "Ahmedabad", "lat": 23.0225, "lng": 72.5714},
    {"name": "Pune", "lat": 18.5204, "lng": 73.8567},
    {"name": "Jaipur", "lat": 26.9124, "lng": 75.7873},
    {"name": "Lucknow", "lat": 26.8467, "lng": 80.9462},
    {"name": "Noida", "lat": 28.5355, "lng": 77.3910},
    {"name": "Gurgaon", "lat": 28.4595, "lng": 77.0266}
  ]
};
