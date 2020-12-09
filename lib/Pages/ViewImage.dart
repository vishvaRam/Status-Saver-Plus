import 'package:flutter/material.dart';
import 'dart:io';

class ViewImage extends StatefulWidget {
  final String path;
  ViewImage({this.path});
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Image"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Hero(
            tag: "${widget.path}",
            child: Image.file(File(widget.path))),
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.download_rounded,size: 26.0,),
      ),
    )
    );
  }
}
