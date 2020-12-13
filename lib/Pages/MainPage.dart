import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Videos.dart';
import 'Images.dart';
import 'Downloads.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String permissionStatus = "";

  listenForPermission() async {
    var status = await Permission.storage.status;

    print(status);
    switch (status) {
      case PermissionStatus.denied:
        await Permission.storage.request();
        var res = await Permission.storage.status;
        setState(() {
          permissionStatus = res.toString();
        });
        break;

      case PermissionStatus.granted:
        setState(() {
          permissionStatus = status.toString();
        });
        break;

      case PermissionStatus.permanentlyDenied:
        setState(() {
          permissionStatus = status.toString();
        });
        break;

      case PermissionStatus.undetermined:
        await Permission.storage.request();
        var res = await Permission.storage.status;
        print(res.toString());
        setState(() {
          permissionStatus = res.toString();
        });
        break;

      case PermissionStatus.restricted:
        setState(() {
          permissionStatus = status.toString();
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    listenForPermission();
  }

  @override
  Widget build(BuildContext context) {
    print(permissionStatus);
    if (permissionStatus == "PermissionStatus.granted") {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(brightness: Brightness.light),
          home: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Status Saver"),
                  actions: [
                    Builder(
                      builder:(context) => IconButton(icon: Icon(Icons.download_rounded), onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Downloads()));
                        print("Clicked");
                      }),
                    )
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.image)),
                      Tab(icon: Icon(Icons.video_collection)),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [Images(), Videos()],
                ),
              ),
            ),
          ));
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
              child: Container(
            child:
                Text("You need to give permission for accessing your storage."),
          )),
        ),
      );
    }
  }
}
