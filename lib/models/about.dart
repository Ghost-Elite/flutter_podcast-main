

import 'package:meta/meta.dart';
import 'dart:convert';
class About {
  bool status;
  DataAbout data;

  About({
    required this.status,
    required this.data,
  });

  factory About.fromRawJson(String str) => About.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory About.fromJson(Map<String, dynamic> json) => About(
    status: json["status"],
    data: DataAbout.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class DataAbout {
  String image;
  String name;
  String email;
  String phone;
  String address;
  dynamic aboutLmt;
  dynamic aboutProject;
  dynamic aboutObservatoire;
  String privacy;

  DataAbout({
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.aboutLmt,
    required this.aboutProject,
    required this.aboutObservatoire,
    required this.privacy,
  });

  factory DataAbout.fromRawJson(String str) => DataAbout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataAbout.fromJson(Map<String, dynamic> json) => DataAbout(
    image: json["image"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    aboutLmt: json["about_lmt"],
    aboutProject: json["about_project"],
    aboutObservatoire: json["about_observatoire"],
    privacy: json["privacy"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "about_lmt": aboutLmt,
    "about_project": aboutProject,
    "about_observatoire": aboutObservatoire,
    "privacy": privacy,
  };
}
