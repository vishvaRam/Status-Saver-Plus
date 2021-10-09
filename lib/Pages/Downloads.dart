import 'package:flutter/material.dart';
import 'dart:io';
import './Downloaded Pages/Downloaded Image.dart';
import './Downloaded Pages/Downloaded Videos.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ColorTheming.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {

  String imagePath = "/storage/emulated/0/Pictures/Status Saver Plus";
  String videosPath = "/storage/emulated/0/Pictures/Status Saver Plus";
  bool isSaved = false;
  bool images = true;
  bool videos = true;
  List<String> imageList = List<String>();
  List<String> videoList = List<String>();

  getImages() async {
    try {
      if(Directory(imagePath).existsSync()){
        var temp = Directory(imagePath)
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith(".jpg"))
            .toList(growable: false);
        setState(() {
          imageList = temp;
        });
      }else{
        setState(() {
          images = false;
        });
      }

    } catch (e) {
      print(e);
    }
  }
  getVideos() async {
    try {
      if(Directory(videosPath).existsSync()){
        var temp = Directory(videosPath)
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith(".mp4"))
            .toList(growable: false);
        setState(() {
          videoList = temp;
        });
      }
      else{
        setState(() {
          videos = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

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
    getImages();
    getVideos();

    if(imageList.length !=0){
      for(int i=0;i<imageList.length;i++){
        print(imageList[i]);
      }
    }
    if(videoList.length != 0){
      for(int i=0;i<videoList.length;i++){
        print(videoList[i]);
      }
    }

    print(images);
    print(videos);
    print(isSaved);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isSaved) {
      return SafeArea(
          child: Scaffold(
            backgroundColor:  Theme.of(context).primaryColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Text("Saved"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: SvgPicture.asset("Assets/empty.svg",placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator()))),
                Flexible(child: Text("You haven't saved anything yet",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
              ],
            ),
          ),
        )
      ));
    } else {
      return DefaultTabController(length: 2, child: SafeArea( child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: backgroundColor,
          title: Text("Saved"),
          bottom: TabBar(
            unselectedLabelColor: accentColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: accentColor,
            ),
            indicatorColor: accentColor,
            labelColor: backgroundColor,
            tabs: [

              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text("Images",textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text("Videos",textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          images ?  DownloadedImages(imageList: imageList.reversed.toList(),getImages: getImages,) : Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: SvgPicture.asset("Assets/empty.svg",placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator()))),
                  Flexible(child: Text("You haven't saved any images yet",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
                ],
              ),
            ),
          ),
          videos ?  DownloadedVideos(videoList: videoList.reversed.toList(),getVideos: getVideos,) : Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: SvgPicture.asset("Assets/empty.svg",placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator()))),
                  Flexible(child: Text("You haven't saved any videos yet",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
                ],
              ),
            ),
          )
        ]),
      ),));
    }
  }
}
