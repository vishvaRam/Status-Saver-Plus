import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class DownloadedVideoPlayer extends StatefulWidget {
  final String path;
  final Function getVideos;
  DownloadedVideoPlayer({this.path,this.getVideos});
  @override
  _DownloadedVideoPlayerState createState() => _DownloadedVideoPlayerState();
}

class _DownloadedVideoPlayerState extends State<DownloadedVideoPlayer> {

  VideoPlayerController _controller;
  Future<void> _initVideoPlayerFuture;


  Widget floatingActionBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(_controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded , size: 26,) ,
          heroTag: null,
          onPressed: () {
            setState(() {
              if(_controller.value.isPlaying){
                _controller.pause();
              }else{
                _controller.play();
              }
            });
          },
        ),
        SizedBox(height: 15.0,),
        FloatingActionButton(onPressed: () async{
          try{
            var res = await File(widget.path).delete(recursive: true);
            widget.getVideos();
            Navigator.pop(context);
            print(res);
          }catch(e){
            print(e);
          }
        },child: Icon(Icons.delete),)
      ],
    );
  }

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.path));
    _initVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    print("Disposing Video");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Video"),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Container(
                child: FutureBuilder(
                  future: _initVideoPlayerFuture,
                  builder: (context,snapshot){

                    if(snapshot.connectionState == ConnectionState.done){
                      return AspectRatio(aspectRatio: _controller.value.aspectRatio ,child: VideoPlayer(_controller),);
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: floatingActionBtn(),
        ));
  }
}
