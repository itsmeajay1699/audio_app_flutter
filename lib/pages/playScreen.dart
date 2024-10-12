import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayScreen extends StatefulWidget {
  final String audioUrl;
  final String img;
  final String durationString; // Pass duration as a string (e.g., "4:20")
  final String title;
  final String description;
  const PlayScreen({super.key, required this.audioUrl, required this.img, required this.durationString, required this.title, required this.description});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero; // Initialize current position
  double sliderValue = 0.0; // Slider value
  late Duration audioDuration; // Store parsed audio duration
  static const int seekDuration = 10; // Duration to seek in seconds

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Parse the duration string to Duration
    audioDuration = _parseDuration(widget.durationString);

    // Listen to the player's position
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
        sliderValue = position.inSeconds.toDouble();
      });
    });
  }

  // Function to parse duration string (e.g., "4:20" to Duration)
  Duration _parseDuration(String durationString) {
    final parts = durationString.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      currentPosition = Duration.zero; // Reset position
      sliderValue = 0.0; // Reset slider
    });
  }

  Future<void> _seekAudio(double value) async {
    Duration newPosition = Duration(seconds: value.toInt());
    await _audioPlayer.seek(newPosition);
  }

  Future<void> _seekForward() async {
    Duration newPosition = currentPosition + Duration(seconds: seekDuration);
    if (newPosition < audioDuration) {
      await _audioPlayer.seek(newPosition);
    }
  }

  Future<void> _seekBackward() async {
    Duration newPosition = currentPosition - Duration(seconds: seekDuration);
    if (newPosition > Duration.zero) {
      await _audioPlayer.seek(newPosition);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: MediaQuery.of(context).size.height * 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.yellow,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: isPlaying ? 0.0 : 1.0,
            duration: Duration(milliseconds: 300),
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        widget.title, // Customize your title here
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      widget.description, // Customize your title here
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(child: Image(image: NetworkImage(widget.img))),
          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${currentPosition.inMinutes}:${(currentPosition.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${audioDuration.inMinutes}:${(audioDuration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Slider
              Slider(
                value: sliderValue,
                min: 0,
                max: audioDuration.inSeconds.toDouble(),
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                  _seekAudio(value);
                },
                thumbColor: Colors.deepOrangeAccent,
                activeColor: Colors.orangeAccent,
              ),
              // Play/Pause/Stop Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10, color: Colors.white), // 10 seconds back
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: Icon(Icons.stop, color: Colors.white),
                      onPressed: _stopAudio,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: isPlaying ? Icon(Icons.pause, color: Colors.white) : Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: isPlaying ? _pauseAudio : _playAudio,
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10, color: Colors.white), // 10 seconds forward
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
