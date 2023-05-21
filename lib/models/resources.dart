// To parse this JSON data, do
//
//     final resources = resourcesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Resources {
  int currentPage;
  List<DataResouces> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Linkes> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Resources({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Resources.fromRawJson(String str) => Resources.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
    currentPage: json["current_page"],
    data: List<DataResouces>.from(json["data"].map((x) => DataResouces.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Linkes>.from(json["links"].map((x) => Linkes.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class DataResouces {
  int id;
  String image;
  String file;
  String name;
  String slug;
  String author;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  DataResouces({
    required this.id,
    required this.image,
    required this.file,
    required this.name,
    required this.slug,
    required this.author,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataResouces.fromRawJson(String str) => DataResouces.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataResouces.fromJson(Map<String, dynamic> json) => DataResouces(
    id: json["id"],
    image: json["image"],
    file: json["file"],
    name: json["name"],
    slug: json["slug"],
    author: json["author"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "file": file,
    "name": name,
    "slug": slug,
    "author": author,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Linkes {
  String url;
  String label;
  bool active;

  Linkes({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Linkes.fromRawJson(String str) => Linkes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Linkes.fromJson(Map<String, dynamic> json) => Linkes(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
