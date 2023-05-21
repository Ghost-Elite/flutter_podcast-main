// To parse this JSON data, do
//
//     final mocs = mocsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Mocs {
  int currentPage;
  List<DataMocs> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Linkis> linkis;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Mocs({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.linkis,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Mocs.fromRawJson(String str) => Mocs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Mocs.fromJson(Map<String, dynamic> json) => Mocs(
    currentPage: json["current_page"],
    data: List<DataMocs>.from(json["data"].map((x) => DataMocs.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    linkis: List<Linkis>.from(json["links"].map((x) => Linkis.fromJson(x))),
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
    "links": List<dynamic>.from(linkis.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class DataMocs {
  int id;
  String image;
  String name;
  String slug;
  String description;
  String by;
  DateTime startAt;
  dynamic file;
  String type;
  String typeUrl;
  DateTime createdAt;
  DateTime updatedAt;

  DataMocs({
    required this.id,
    required this.image,
    required this.name,
    required this.slug,
    required this.description,
    required this.by,
    required this.startAt,
    required this.file,
    required this.type,
    required this.typeUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataMocs.fromRawJson(String str) => DataMocs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataMocs.fromJson(Map<String, dynamic> json) => DataMocs(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    by: json["by"],
    startAt: DateTime.parse(json["start_at"]),
    file: json["file"],
    type: json["type"],
    typeUrl: json["type_url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "slug": slug,
    "description": description,
    "by": by,
    "start_at": startAt.toIso8601String(),
    "file": file,
    "type": type,
    "type_url": typeUrl,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Linkis {
  String url;
  String label;
  bool active;

  Linkis({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Linkis.fromRawJson(String str) => Linkis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Linkis.fromJson(Map<String, dynamic> json) => Linkis(
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
