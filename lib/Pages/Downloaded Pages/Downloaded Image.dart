import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'ViewDownloadedImage.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';

class DownloadedImages extends StatefulWidget {

  final List<String> imageList;
  final Function getImages;
  DownloadedImages({this.imageList,this.getImages});
  @override
  _DownloadedImagesState createState() => _DownloadedImagesState();
}

class _DownloadedImagesState extends State<DownloadedImages> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if(widget.imageList.length == 0){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: SvgPicture.asset("Assets/empty.svg",placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(30.0),
                  child: const CircularProgressIndicator()))),
              Flexible(child: Text("We can't find any images",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
            ],
          ),
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12.0),
        child: StaggeredGridView.countBuilder(crossAxisCount: 4,itemCount: widget.imageList.length,  itemBuilder: (context,index){
          String imgPath = widget.imageList[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              elevation: 4.0,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewDownloadedImage(path: widget.imageList[index],getImages: widget.getImages,) ) );
                },
                child: Hero(
                    tag: imgPath,
                    child: Image.file(File(imgPath),fit: BoxFit.cover,)),
              ),
            ),
          );
        }, staggeredTileBuilder: (i) =>
            StaggeredTile.count(2, i.isEven ? 2 : 3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
