import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final Directory imageDir =
new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class Images extends StatefulWidget {
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images>  with AutomaticKeepAliveClientMixin{

  List<String> imageList = List<String>();

  getImages() async {
    try {
      imageList = imageDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);

    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    print("Images init called");
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StaggeredGridView.countBuilder(crossAxisCount: 4,itemCount: imageList.length,  itemBuilder: (context,index){
        String imgPath = imageList[index];
        return Material(
          child: InkWell(
            child: Image.file(File(imgPath),fit: BoxFit.cover,),
          ),
        );
      }, staggeredTileBuilder: (i) =>
          StaggeredTile.count(2, i.isEven ? 2 : 3),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
