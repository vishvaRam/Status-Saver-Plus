import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:share/share.dart';

import 'ColorTheming.dart';

class ViewImage extends StatefulWidget {
  final String path;
  ViewImage({this.path});
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  String savingPath = "/storage/emulated/0/Pictures/Status Saver Plus";
  String fileName = "";

  @override
  void initState() {
    print(widget.path);
    File fullPath = File(widget.path);
    String temp = fullPath.path.split("/").last;
    print(temp);
    setState(() {
      fileName = temp;
    });
    print("File name: $fileName");
    super.initState();
  }

  void isLoading(BuildContext context, bool isLoading, String str) {
    if (isLoading) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Theme.of(context).primaryColor,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          "Great, Saved in Gallery",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text(
                          str,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Text("FileManager > Pictures > Status Saver Plus",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).accentColor)),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        MaterialButton(
                          child: Text("Close"),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Image"),
      ),
      body: Builder(
        builder: (context) => Container(
          color: Theme.of(context).primaryColor,
          child: Hero(
              tag: "${widget.path}",
              // child: Image.file(File(widget.path))),
              child:PhotoView(
                imageProvider: FileImage(File(widget.path)),
              )
          )
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              try {
                String path = savingPath;
                String newFile = "$path/$fileName";

                if (File(newFile).existsSync()) {
                  print("Exist");
                  _scaffoldstate.currentState.showSnackBar(SnackBar(
                    content: Text("Already exist!"),
                  ));
                  return;
                }

                isLoading(context, true, "");

                File originalImageFile = File(widget.path);

                if (!Directory(savingPath).existsSync()) {
                  Directory(savingPath).createSync(recursive: true);
                }

                print(newFile);
                await originalImageFile.copy(newFile);
                isLoading(context, false,
                    "If Image not available in gallery\n\nYou can find all images at");
              } catch (e) {
                Navigator.pop(context);
                print(e);
                _scaffoldstate.currentState.showSnackBar(SnackBar(
                  content: Text("Something went wrong!"),
                ));
              }
            },
            child: Icon(
              Icons.download_rounded,
              size: 26.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Share.shareFiles([widget.path]);
            },
            child: Icon(
              Icons.share_rounded,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    ));
  }
}
