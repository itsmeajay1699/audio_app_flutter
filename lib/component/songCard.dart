import 'package:flutter/material.dart';
import 'package:kuku_fm/models/bajanModel.dart';
import 'package:kuku_fm/models/programs.dart';
import 'package:kuku_fm/pages/details.dart';

class SongCard extends StatefulWidget {
  final Program song;
  final int index;

  const SongCard({Key? key, required this.song, required this.index})
      : super(key: key);

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Add a delay to show fade-in effect
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsPage(program: widget.song,name: widget.song.name,),
            ),
          );
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              // Background Image
              Hero(
                tag: widget.song.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.song.img,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black12, // Semi-transparent background
                ),
              ),
              // Text overlay
              Positioned(
                bottom: 10,
                left: 10,
                right: 10, // Ensure the text respects the card's padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        widget.song.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.song.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    // Description Text
                  ],
                ),
              ),
              // Play icon
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white70,
                  ),
                  child: Icon(Icons.lock_open, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
