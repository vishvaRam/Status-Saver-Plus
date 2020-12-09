import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'ViewVideo.dart';

final Directory videoDir =
    new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> with AutomaticKeepAliveClientMixin {

  List<String> videoList = List<String>();

  Future<String> getThumbnail(String videoPath) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String thumb = await VideoThumbnail.thumbnailFile(video: videoPath,quality: 80,imageFormat: ImageFormat.JPEG,thumbnailPath: tempPath);
    return thumb;
  }
  deleteThumb() async{
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
      return Center(child: Text("Install WhatsApp!"));
    } else {
      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            itemCount: videoList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2.0 / 3.0),
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: getThumbnail(videoList[index]),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Container(
                        padding: EdgeInsets.all(6),
                        child: Material(
                           elevation: 6.0,
                            child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewVideo(path: videoList[index])));
                                },
                                child: Hero(
                                    tag: snapshot.data,
                                    child: Image.file(File(snapshot.data),fit: BoxFit.cover)))),
                      );
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              }));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
