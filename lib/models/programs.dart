import 'dart:convert'; // Required for json decoding

class Program {
  final String id;
  final String name;
  final String description;
  final String duration;
  final String instructor;
  final String img;

  // Constructor
  Program({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.instructor,
    required this.img,
  });

  // Factory method to create a Program instance from JSON
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      duration: json['duration'] as String,
      instructor: json['instructor'] as String,
      img: json['img'] as String,
    );
  }

  // Convert a Program instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'instructor': instructor,
      'img': img,
    };
  }
}
