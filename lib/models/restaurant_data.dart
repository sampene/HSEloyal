class Restaurant_Data {
  List<Restaurants> restaurants;

  Restaurant_Data({this.restaurants});

  Restaurant_Data.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = new List<Restaurants>();
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurants {
  int id;
  String name;
  String neighborhood;
  String photograph;
  String address;
  String ethAddress;
  Latlng latlng;
  String cuisineType;
  OperatingHours operatingHours;
  List<Reviews> reviews;

  Restaurants(
      {this.id,
        this.name,
        this.neighborhood,
        this.photograph,
        this.address,
        this.ethAddress,
        this.latlng,
        this.cuisineType,
        this.operatingHours,
        this.reviews});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    neighborhood = json['neighborhood'];
    photograph = json['photograph'];
    address = json['address'];
    ethAddress = json['eth_address'];
    latlng =
    json['latlng'] != null ? new Latlng.fromJson(json['latlng']) : null;
    cuisineType = json['cuisine_type'];
    operatingHours = json['operating_hours'] != null
        ? new OperatingHours.fromJson(json['operating_hours'])
        : null;
    if (json['reviews'] != null) {
      reviews = new List<Reviews>();
      json['reviews'].forEach((v) {
        reviews.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['neighborhood'] = this.neighborhood;
    data['photograph'] = this.photograph;
    data['address'] = this.address;
    data['eth_address'] = this.ethAddress;
    if (this.latlng != null) {
      data['latlng'] = this.latlng.toJson();
    }
    data['cuisine_type'] = this.cuisineType;
    if (this.operatingHours != null) {
      data['operating_hours'] = this.operatingHours.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Latlng {
  double lat;
  double lng;

  Latlng({this.lat, this.lng});

  Latlng.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class OperatingHours {
  String monday;
  String tuesday;
  String wednesday;
  String thursday;
  String friday;
  String saturday;
  String sunday;

  OperatingHours(
      {this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday,
        this.sunday});

  OperatingHours.fromJson(Map<String, dynamic> json) {
    monday = json['Monday'];
    tuesday = json['Tuesday'];
    wednesday = json['Wednesday'];
    thursday = json['Thursday'];
    friday = json['Friday'];
    saturday = json['Saturday'];
    sunday = json['Sunday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Monday'] = this.monday;
    data['Tuesday'] = this.tuesday;
    data['Wednesday'] = this.wednesday;
    data['Thursday'] = this.thursday;
    data['Friday'] = this.friday;
    data['Saturday'] = this.saturday;
    data['Sunday'] = this.sunday;
    return data;
  }
}

class Reviews {
  String name;
  String date;
  int rating;
  String comments;

  Reviews({this.name, this.date, this.rating, this.comments});

  Reviews.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    rating = json['rating'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['date'] = this.date;
    data['rating'] = this.rating;
    data['comments'] = this.comments;
    return data;
  }
}
