import 'package:flutter/material.dart';
import 'dart:io';

class ViewDownloadedImage extends StatefulWidget {
  final String path;
  final Function getImages;
  ViewDownloadedImage({this.path,this.getImages});
  @override
  _ViewDownloadedImageState createState() => _ViewDownloadedImageState();
}

class _ViewDownloadedImageState extends State<ViewDownloadedImage> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Image"),),
        body: Container(
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: Hero(
              tag: "${widget.path}",
              child: Image.file(File(widget.path))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
           try{
             var res = await File(widget.path).delete(recursive: true);
             widget.getImages();
             Navigator.pop(context);
             print(res);
           }catch(e){
             print(e);
           }
           } ,
          child: Icon(Icons.delete,color: Theme.of(context).primaryColor,size: 26,),
        ),
      ),
    );
  }
}
