import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class ViewImage extends StatefulWidget {
  final String path;
  ViewImage({this.path});
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {

  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  String savingPath = "/storage/emulated/0/Status Saver/Images";
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
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text("Great, Saved in Gallery", style: TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.bold
                      ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0),),
                      Text(str,style:TextStyle( fontSize:16.0, ),textAlign: TextAlign.center,),
                      Padding(padding: EdgeInsets.all(10.0),),
                      Text("FileManager > Status Saver > Images",style:TextStyle( fontSize:16.0, color: Colors.blue )),
                      Padding(padding: EdgeInsets.all(10.0),),
                      MaterialButton(
                        child: Text("Close"),
                        color:Colors.blue,
                        textColor: Colors.white,
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
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text("Image"),
      ),
      body: Builder(
        builder:(context)=> Container(
          height: MediaQuery.of(context).size.height/1.2,
          width: MediaQuery.of(context).size.height,
          child: Hero(
              tag: "${widget.path}",
              child: Image.file(File(widget.path))),
         ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          try{

            String path = savingPath;
            String newFile = "$path/$fileName";

            if(File(newFile).existsSync()){
              print("Exist");
              _scaffoldstate.currentState.showSnackBar(SnackBar(content: Text("Already exist!"), ));
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
            _scaffoldstate.currentState.showSnackBar(SnackBar(content: Text("Something went wrong!"), ));
          }

        },
        child: Icon(Icons.download_rounded,size: 26.0,),
      ),
    )
    );
  }
}
