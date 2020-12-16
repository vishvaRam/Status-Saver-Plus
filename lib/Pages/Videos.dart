import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'ViewVideo.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Directory videoDir =
    new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> with AutomaticKeepAliveClientMixin {
  List<String> videoList = List<String>();

  Future<String> getThumbnail(String videoPath) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String thumb = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        quality: 80,
        imageFormat: ImageFormat.JPEG,
        thumbnailPath: tempPath);
    return thumb;
  }

  deleteThumb() async {
    Directory tempDir = await getTemporaryDirectory();
    print("Deleted Thumb");
    tempDir.deleteSync();
  }

  getVideos() async {
    try {
      videoList = videoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList(growable: false);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print("Video init called");

    getVideos();
    super.initState();
  }

  @override
  void dispose() {
    deleteThumb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!Directory('${videoDir.path}').existsSync()) {
      return Container(
        height: MediaQuery.of(context).size.height/1.2,
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: SvgPicture.asset("Assets/install.svg",placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator()))),
            Flexible(child: Text("Install WhatsApp and try again!",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
          ],
        ),
      );
    } else {
      if(videoList.length==0){
        return Container(
          height: MediaQuery.of(context).size.height/1.2,
          padding: EdgeInsets.symmetric(horizontal: 30),
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: SvgPicture.asset("Assets/empty.svg",placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator()))),
              Flexible(child: Text("We can't find any videos",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
            ],
          ),
        );
      }
      else{
        return Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            child: GridView.builder(
                itemCount: videoList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2.0 / 3.0),
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: getThumbnail(videoList[index]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                                elevation: 6.0,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewVideo(
                                                  path: videoList[index])));
                                    },
                                    child: Hero(
                                      tag: snapshot.data,
                                      child: Image.file(File(snapshot.data),
                                          fit: BoxFit.cover),))),
                          ),
                            // Align(alignment: Alignment.topRight,child: Icon(Icons.videocam),),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }));
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
