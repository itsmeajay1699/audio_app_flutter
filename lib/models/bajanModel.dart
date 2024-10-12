// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  String id;
  String title;
  String artist;
  String firebaseUrl;
  String duration;
  String description;
  String img;

  Welcome({
    required this.id,
    required this.title,
    required this.artist,
    required this.firebaseUrl,
    required this.duration,
    required this.description,
    required this.img,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    id: json["_id"],
    title: json["title"],
    artist: json["artist"],
    firebaseUrl: json["firebaseUrl"],
    duration: json["duration"],
    description: json["description"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "artist": artist,
    "firebaseUrl": firebaseUrl,
    "duration": duration,
    "description": description,
    "img": img,
  };
}
