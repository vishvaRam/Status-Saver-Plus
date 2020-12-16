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
  final Color backgroundColor = Color(0xff1C1D36);
  final Color accentColor = Color(0xff4FE3C1);

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
          theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: backgroundColor,
              accentColor: accentColor),
          home: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                drawer: Drawer(
                  elevation: 12.0,
                  child: Container(
                    color: backgroundColor,
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text("H1")
                        )
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                  elevation: 0.0,
                  title: Text("Status Saver"),
                  actions: [
                    Builder(
                      builder: (context) => IconButton(
                          icon: Icon(Icons.download_rounded),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Downloads()));
                          }),
                    )
                  ],
                  bottom: TabBar(
                    unselectedLabelColor: accentColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: accentColor,
                    ),
                    indicatorColor: accentColor,
                    labelColor: backgroundColor,
                    tabs: [
                      Tab(
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Images"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Videos"),
                          ),
                        ),
                      ),
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
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: backgroundColor,
            accentColor: accentColor),
        home: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
              child: Container(
            child:
                Text("You need to give permission for accessing your storage.",style: TextStyle(color: accentColor),),
          )),
        ),
      );
    }
  }
}
