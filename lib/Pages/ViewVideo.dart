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
  final GlobalKey<ScaffoldState> _scaffoldVideo = GlobalKey<ScaffoldState>();

  String savingPath = "/storage/emulated/0/Status Saver/Videos";
  String fileName = "";

  Widget floatingActionBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(Icons.download_rounded,size: 26,),
          heroTag: null,
          onPressed: () async {
            try{

              String path = savingPath;
              String newFile = "$path/$fileName";

              if(File(newFile).existsSync()){
                print("Exist");
                _scaffoldVideo.currentState.showSnackBar(SnackBar(content: Text("Already exist!"), ));
                return;
              }

              isLoading(context,true, "");

              File originalImageFile = File(widget.path);

              if(!Directory(savingPath).existsSync()){
                Directory(savingPath).createSync(recursive: true);
              }

              print(newFile);
              await originalImageFile.copy(newFile);
              isLoading(context,false, "If Image not available in gallery\n\nYou can find all images at");
            }
            catch(e){
              Navigator.pop(context);
              print(e);
              _scaffoldVideo.currentState.showSnackBar(SnackBar(content: Text("Something went wrong!"), ));
            }

          },
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

  void isLoading(BuildContext context,bool isLoading,String str){
    if(isLoading){
      showDialog(barrierDismissible: false,context: context,builder: (context){
        return SimpleDialog(
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      });
    }else{
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return SimpleDialog(
              backgroundColor: Theme.of(context).primaryColor,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("Great, Saved in Gallery", style: TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        ),
                        Padding(padding: EdgeInsets.all(10.0),),
                        Text(str,style:TextStyle( fontSize:16.0,color: Colors.white ),textAlign: TextAlign.center,),
                        Padding(padding: EdgeInsets.all(10.0),),
                        Text("FileManager > Status Saver > Videos",style:TextStyle( fontSize:16.0, color: Theme.of(context).accentColor )),
                        Padding(padding: EdgeInsets.all(10.0),),
                        MaterialButton(
                          child: Text("Close"),
                          color:Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          onPressed:  ()=> Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
      );
    }
  }


  @override
  void initState() {

    File fullPath = File(widget.path);
    String temp = fullPath.path.split("/").last;
    print(temp);
    setState(() {
      fileName = temp;
    });
    print("File name: $fileName");

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
          key: _scaffoldVideo,
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
