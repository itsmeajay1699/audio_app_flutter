import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuku_fm/component/songCard.dart';
import 'package:kuku_fm/models/bajanModel.dart';
import 'package:kuku_fm/models/programs.dart';

class SongComponent extends StatefulWidget {
  const SongComponent({super.key});

  @override
  State<SongComponent> createState() => _SongComponentState();
}

class _SongComponentState extends State<SongComponent> {
  List<Program> result = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await http
        .get(Uri.parse("http://192.168.0.109:4000/api/v1/program/all"));
    List<dynamic> jsonList = jsonDecode(response.body);
    List<Program> programList = jsonList.map((json) => Program.fromJson(json)).toList();

    setState(() {
      result = programList;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CupertinoActivityIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.deepOrange, // Starting color
                      Colors.orange, // Ending color
                    ],
                    begin:
                    Alignment.topCenter, // Gradient starts from the top
                    end:
                    Alignment.bottomCenter, // Gradient ends at the bottom
                  ).createShader(bounds),
                  child: Text(
                    "Prarthana Plans!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      childAspectRatio: 0.8, // Aspect ratio for each item
                      mainAxisSpacing: 10, // Space between rows
                      crossAxisSpacing: 10, // Space between columns
                    ),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return SongCard(song: result[index], index: index);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

