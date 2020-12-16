import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'PlayDownloadedVideo.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DownloadedVideos extends StatefulWidget {
  final List<String> videoList;
  final Function getVideos;
  DownloadedVideos({this.videoList,this.getVideos});
  @override
  _DownloadedVideosState createState() => _DownloadedVideosState();
}

class _DownloadedVideosState extends State<DownloadedVideos> with AutomaticKeepAliveClientMixin {


  Future<String> getThumbnail(String videoPath) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String thumb = await VideoThumbnail.thumbnailFile(video: videoPath,quality: 80,imageFormat: ImageFormat.JPEG,thumbnailPath: tempPath);
    return thumb;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(widget.videoList.length == 0){
      return Container(
        height: MediaQuery.of(context).size.height/1.2,
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: SvgPicture.asset("Assets/empty.svg")),
            Flexible(child: Text("You haven't saved any videos yet",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
          ],
        ),
      );
    }
    else{
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
        child: GridView.builder(
            itemCount: widget.videoList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2.0 / 3.0),
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: getThumbnail(widget.videoList[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      padding: EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                            elevation: 6.0,
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DownloadedVideoPlayer(path: widget.videoList[index],getVideos: widget.getVideos,)));
                                },
                                child: Hero(
                                    tag: snapshot.data,
                                    child: Image.file(File(snapshot.data),
                                        fit: BoxFit.cover)))),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
