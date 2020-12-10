import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  final String path;
  ViewVideo({this.path});

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {

  VideoPlayerController _controller;
  Future<void> _initVideoPlayerFuture;

  Widget floatingActionBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(Icons.download_rounded,size: 26,),
          heroTag: null,
          onPressed: () {},
        ),
        SizedBox(
          height: 10.0,
        ),
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
        )
      ],
    );
  }

  @override
  void initState() {

    _controller = VideoPlayerController.file(File(widget.path));
    _initVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);

    print(widget.path);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Video"),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder(
            future: _initVideoPlayerFuture,
            // ignore: missing_return
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
      floatingActionButton: floatingActionBtn(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    print("Disposing Video");
  }
}
