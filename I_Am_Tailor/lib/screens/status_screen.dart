import 'dart:async';
import 'dart:isolate';

import 'package:I_Am_Tailor/locale/app_localization.dart';
import 'package:I_Am_Tailor/locale/localInfo.dart';
import 'package:I_Am_Tailor/screens/make_request.dart';
import 'package:I_Am_Tailor/screens/on_working.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:I_Am_Tailor/common/nav.drower.dart';
// import 'package:I_Am_Tailor/test_screen.dart';
import 'package:I_Am_Tailor/screens/homepage.dart';
import 'package:I_Am_Tailor/handle_cloud/data_file.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

// pushReplacement is giving warning! , check later
  Future deleteRequestMethod(LocalInfo localData, BuildContext context) async {
    await deleteRequest(localData);
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (newcontext) => RequestPage()));
  }

  void onRefresh(BuildContext context, LocalInfo localData) async {
    await checkStatus(context, localData);
  }

  @override
  Widget build(BuildContext context) {
    LocalInfo localData = Provider.of<LocalInfo>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Request Status"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ],
          ),
        ),
        alignment: Alignment.topCenter,
        child: RefreshIndicator(
          onRefresh: () async {
            print("hello");
            onRefresh(context, localData);
            return;
          },
          child: ListView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: RefreshIndicator(
                    onRefresh: () {
                      onRefresh(context, localData);
                      return;
                    },
                    child: Container(
                      child: Text(
                        "CHOUDHARY TAILORS",
                        style: TextStyle(
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[700]),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.amber)),
                  ),
                  child: Text(
                    "SUN INDIA SHOWROOM",
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: GestureDetector(
                    onDoubleTap: () async {
                      await deleteRequestMethod(localData, context);
                    },
                    child: Text(
                      "Requested",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              child:
                                  Text("Name", style: TextStyle(fontSize: 20)),
                            ),
                            Expanded(
                              child: Text(LocalInfo.name,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue[900])),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              child: Text("Profile",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Expanded(
                              child: Text(LocalInfo.profile,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue[900])),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              child: Text("Phone No.",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Expanded(
                              child: Text(LocalInfo.loginPhone,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue[900])),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 130,
                              child: Text("Accepted",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Expanded(
                              child: Text(
                                  (LocalInfo.requestAccepted
                                      ? "Yes"
                                      : "Not Yet"),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue[900])),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
