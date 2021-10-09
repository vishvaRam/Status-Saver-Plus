import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ColorTheming.dart';
import 'Videos.dart';
import 'Images.dart';
import 'package:open_appstore/open_appstore.dart';
import 'Downloads.dart';
import 'package:share/share.dart';
import 'package:permission/permission.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  String permissionStatus = "";

  listenForPermission() async {
    var status =
        await Permission.getPermissionsStatus([PermissionName.Storage]);

    status.forEach((permission) {
      print('${permission.permissionName}: ${permission.permissionStatus}\n');
      setState(() {
        permissionStatus = permission.permissionStatus.toString();
      });
    });

    switch (permissionStatus) {
      case "PermissionStatus.deny":
        await Permission.requestPermissions([PermissionName.Storage]);
        var status =
            await Permission.getPermissionsStatus([PermissionName.Storage]);

        status.forEach((permission) {
          print(
              '${permission.permissionName}: ${permission.permissionStatus}\n');
          setState(() {
            permissionStatus = permission.permissionStatus.toString();
          });
        });
        break;

      case "PermissionStatus.allow":
        var status =
            await Permission.getPermissionsStatus([PermissionName.Storage]);

        status.forEach((permission) {
          print(
              '${permission.permissionName}: ${permission.permissionStatus}\n');
          setState(() {
            permissionStatus = permission.permissionStatus.toString();
          });
        });

        break;

      case "PermissionStatus.notAgain":
        await Permission.requestPermissions([PermissionName.Storage]);
        var status =
            await Permission.getPermissionsStatus([PermissionName.Storage]);

        status.forEach((permission) {
          print(
              '${permission.permissionName}: ${permission.permissionStatus}\n');
          setState(() {
            permissionStatus = permission.permissionStatus.toString();
          });
        });

        break;

      case "PermissionStatus.always":
        await Permission.requestPermissions([PermissionName.Storage]);
        var status =
            await Permission.getPermissionsStatus([PermissionName.Storage]);

        status.forEach((permission) {
          print(
              '${permission.permissionName}: ${permission.permissionStatus}\n');
          setState(() {
            permissionStatus = permission.permissionStatus.toString();
          });
        });

        break;

      case "PermissionStatus.notDecided":
        await Permission.requestPermissions([PermissionName.Storage]);
        var status =
            await Permission.getPermissionsStatus([PermissionName.Storage]);

        status.forEach((permission) {
          print(
              '${permission.permissionName}: ${permission.permissionStatus}\n');
          setState(() {
            permissionStatus = permission.permissionStatus.toString();
          });
        });

        break;

      case "PermissionStatus.whenInUse":
        await Permission.requestPermissions([PermissionName.Storage]);
        var status =
            await Permission.getPermissionsStatus([PermissionName.Storage]);

        status.forEach((permission) {
          print(
              '${permission.permissionName}: ${permission.permissionStatus}\n');
          setState(() {
            permissionStatus = permission.permissionStatus.toString();
          });
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
    if (permissionStatus == "PermissionStatus.allow") {
      print("permission in true");
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: backgroundColor,
              canvasColor: backgroundColor,
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: accentColor)),
          home: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: backgroundColor,
                drawer: Drawer(
                  elevation: 12.0,
                  child: ListView(
                    children: [
                      DrawerHeader(
                        child: Center(
                          child: SvgPicture.asset("Assets/hello.svg",
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                      padding: const EdgeInsets.all(30.0),
                                      child:
                                          const CircularProgressIndicator())),
                        ),
                      ),
                      // Divider(color: accentColor,height: 1,),
                      ListTile(
                        title: Text(
                          "Share",
                          style: TextStyle(color: accentColor, fontSize: 18.0),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.share_rounded, color: accentColor),
                          onPressed: () {
                            Share.share(
                                "https://play.google.com/store/apps/details?id=com.vishva.status.saver.plus",
                                subject: "Status Saver Plus App");
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Review this App",
                          style: TextStyle(color: accentColor, fontSize: 18.0),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.rate_review_rounded,
                              color: accentColor),
                          onPressed: () {
                            OpenAppstore.launch(
                                androidAppId: "com.vishva.status.saver.plus",
                                iOSAppId: null);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: backgroundColor,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "Assets/img.png",
                        height: 35,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Status Saver Plus"),
                    ],
                  ),
                  actions: [
                    Builder(
                      builder: (context) => IconButton(
                          icon: Icon(
                            Icons.download_rounded,
                            size: 26,
                          ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Images",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Videos",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
      print("permission in false");
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: backgroundColor,
            accentColor: accentColor),
        home: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "You need to give permission for accessing your storage.",
                  style: TextStyle(color: accentColor),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: accentColor,
                  onPressed: () {
                    listenForPermission();
                  },
                  child: Text(
                    "Give Storage Permission",
                    style: TextStyle(color: backgroundColor, fontSize: 18.0),
                  ))
            ],
          )),
        ),
      );
    }
  }
}
