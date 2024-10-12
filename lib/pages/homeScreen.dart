import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kuku_fm/component/songList.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    final List<Widget> _pages = [
      Center(child: Text('Home')),
      Center(child: Text('Songs')),
      Center(child: Text('Library')),
      Center(child: Text('Settings')),
    ];
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Set your desired height
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0), // Add vertical padding
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange, // Starting color (top)
                Colors.white, // Ending color (bottom)
              ],
              begin: Alignment.topCenter, // Gradient starts from the top
              end: Alignment.bottomCenter, // Gradient ends at the bottom
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor:
                Colors.transparent, // Make AppBar transparent if needed
            leading: Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(left: 20),
              child: SvgPicture.network(
                "https://www.svgrepo.com/show/406817/orange-circle.svg",
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              'InnerBhakti',
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/image/headphones-listening.svg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Discover the Best Bajan!',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12), // Space between the banner and next content
            // Additional Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.orange, // Starting color
                        Colors.white, // Ending color
                      ],
                      begin:
                          Alignment.topCenter, // Gradient starts from the top
                      end:
                          Alignment.bottomCenter, // Gradient ends at the bottom
                    ).createShader(bounds),
                    child: Text(
                      "All the latest Bhakti bajan!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Explore a vast collection of songs and enjoy your favorites.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            // Songs List with defined height
            Container(
              height: MediaQuery.of(context).size.height -
                  300, // Adjust the height accordingly
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SongComponent(),
            ),
          ],
        ),
      ),
    );
  }
}
