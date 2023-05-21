// To parse this JSON data, do
//
//     final club = clubFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Club {
  bool status;
  List<DataClub> data;

  Club({
    required this.status,
    required this.data,
  });

  factory Club.fromRawJson(String str) => Club.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Club.fromJson(Map<String, dynamic> json) => Club(
    status: json["status"],
    data: List<DataClub>.from(json["data"].map((x) => DataClub.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataClub {
  String image;
  String name;
  String slug;
  String publicationUrl;
  String description;

  DataClub({
    required this.image,
    required this.name,
    required this.slug,
    required this.publicationUrl,
    required this.description,
  });

  factory DataClub.fromRawJson(String str) => DataClub.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataClub.fromJson(Map<String, dynamic> json) => DataClub(
    image: json["image"],
    name: json["name"],
    slug: json["slug"],
    publicationUrl: json["publication_url"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "slug": slug,
    "publication_url": publicationUrl,
    "description": description,
  };
}
