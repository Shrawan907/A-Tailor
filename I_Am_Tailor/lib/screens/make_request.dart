import 'dart:async';
import 'dart:isolate';

import 'package:I_Am_Tailor/locale/app_localization.dart';
import 'package:I_Am_Tailor/locale/localInfo.dart';
import 'package:I_Am_Tailor/screens/on_working.dart';
import 'package:I_Am_Tailor/screens/status_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:I_Am_Tailor/common/nav.drower.dart';
// import 'package:I_Am_Tailor/test_screen.dart';
import 'package:I_Am_Tailor/screens/homepage.dart';
import 'package:I_Am_Tailor/handle_cloud/data_file.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String _username;
  String _profile;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  void sendRequest(LocalInfo localData) async {
    SnackBar sanckBar;
    print(localData.loginPhone.length);
    if (_username != null &&
        _profile != null &&
        _username.length > 3 &&
        _username.length < 25 &&
        localData.loginPhone.length == 13) {
      await makeRequest(_username, _profile, localData, context);
    } else {
      sanckBar = SnackBar(content: Text("Username format is not correct"));
      _scaffoldKey.currentState.showSnackBar(sanckBar);
      Timer(Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalInfo localData = Provider.of<LocalInfo>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Send Request"),
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
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "CHOUDHARY TAILORS",
                  style: TextStyle(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700]),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 2, color: Colors.amber)),
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
                width: 300,
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _username = value;
                  },
                  style: TextStyle(fontSize: 22),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(fontSize: 15),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: 300,
                height: 50,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  border: Border.all(width: 0.5),
                ),
                child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    hint: Text("Select"),
                    value: _profile,
                    items: <String>[
                      'SHIRT MAKER',
                      'PENT MAKER',
                      'COAT MAKER',
                      'CUTTER'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _profile = value;
                      setState(() {});
                    }),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: 180,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    sendRequest(localData);
                  },
                  child: Text(
                    "Sent Request",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      side: BorderSide(color: Colors.white)),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
