import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'ViewImage.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getImages();
    super.build(context);
    if(!Directory(imageDir.path).existsSync()){
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
    }else{
      if(imageList.length==0){
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
              Flexible(child: Text("We can't find any images",style: TextStyle(fontSize: 16.0,color:Theme.of(context).accentColor, ),))
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
          child: StaggeredGridView.countBuilder(crossAxisCount: 4,itemCount: imageList.length,  itemBuilder: (context,index){
            String imgPath = imageList[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                elevation: 4.0,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewImage(path: imgPath,) ) );
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
  }

  @override
  bool get wantKeepAlive => false;
}
