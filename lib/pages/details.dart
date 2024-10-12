import 'package:flutter/material.dart';
import 'package:kuku_fm/models/bajanModel.dart';
import 'package:kuku_fm/models/programs.dart';
import 'package:kuku_fm/models/track.dart';
import 'package:kuku_fm/pages/playScreen.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API calls

class DetailsPage extends StatefulWidget {
  final Program program;
  final String name;

  const DetailsPage({
    super.key,
    required this.name,
    required this.program,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Track>? tracks; // State to store fetched tracks
  bool isLoading = true; // State to track loading status

  @override
  void initState() {
    super.initState();
    fetchTracks(); // Call API when widget initializes
  }

  // API call to fetch tracks based on program name
  Future<void> fetchTracks() async {
    final url =
        'http://192.168.0.109:4000/api/v1/program/tracks/${Uri.encodeComponent(widget.program.name)}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Track> fetchedTracks =
            jsonList.map((json) => Track.fromJson(json)).toList();

        setState(() {
          tracks = fetchedTracks;
          isLoading = false; // Data fetched, stop loading
        });
      } else {
        throw Exception('Failed to load tracks');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background gradient
                Container(
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange,
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Program Image
                Hero(
                  tag: widget.program.id,
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.program.img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Main content section
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1 -
                          MediaQuery.of(context).size.height * 0.3,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange,
                            blurRadius: 60,
                            spreadRadius: 5,
                            offset: const Offset(0, -30),
                          ),
                        ],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Program Name
                          Text(
                            widget.program.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Program Description
                          Text(
                            widget.program.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Display tracks or loading indicator
                          isLoading
                              ? Center(child: const CircularProgressIndicator())
                              : tracks != null && tracks!.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: tracks!.length,
                                      itemBuilder: (context, index) {
                                        final track = tracks![index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayScreen(
                                                  audioUrl: track.audioUrl,
                                                  img: widget.program.img,
                                                  durationString:
                                                      track.duration,
                                                  title: track.title,
                                                  description: widget
                                                      .program.description,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.orange,
                                              radius: 15,
                                              child: Icon(Icons.music_note,
                                                  color: Colors.white,
                                                  size: 20),
                                            ),
                                            title: Text(
                                              track.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                const Icon(Icons.timer,
                                                    color: Colors.grey,
                                                    size: 16),
                                                const SizedBox(width: 5),
                                                Text(
                                                  track.duration,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.play_arrow,
                                                  color: Colors.orange,
                                                  size: 30),
                                              onPressed: () {},
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            tileColor:
                                                Colors.white.withOpacity(0.1),
                                          ),
                                        );
                                      },
                                    )
                                  : const Text(
                                      'No tracks available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
