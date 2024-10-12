class Track {
  final String id;
  final String title;
  final String duration;
  final String programName;
  final String audioUrl;

  Track({
    required this.id,
    required this.title,
    required this.duration,
    required this.programName,
    required this.audioUrl,
  });

  // Factory constructor to create a Track object from JSON
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['_id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      programName: json['programName'] as String,
      audioUrl: json['audioUrl'] as String,
    );
  }

  // Method to convert a Track object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'duration': duration,
      'programName': programName,
      'audioUrl': audioUrl,
    };
  }

  // Factory constructor to create a list of Tracks from a JSON array
  static List<Track> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Track.fromJson(json)).toList();
  }
}
