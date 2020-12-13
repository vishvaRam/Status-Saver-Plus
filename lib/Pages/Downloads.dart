import 'package:flutter/material.dart';
import 'dart:io';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  String imagePath = "/storage/emulated/0/Status Saver/Images";
  String videosPath = "/storage/emulated/0/Status Saver/Videos";
  bool isSaved = false;

  checkDownloaded() {
    Directory imgPath = Directory(imagePath);
    Directory vidPath = Directory(videosPath);

    if (imgPath.existsSync() || vidPath.existsSync()) {
      setState(() {
        isSaved = true;
      });
    }
  }

  @override
  void initState() {
    checkDownloaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isSaved) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Saved"),
        ),
        body: Center(
          child: Text("Nothing is saved"),
        ),
      ));
    } else {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Saved"),
        ),
        body: Center(
          child: Text("Saved"),
        ),
      ));
    }
  }
}
