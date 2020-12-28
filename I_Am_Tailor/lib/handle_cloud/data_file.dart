import 'dart:async';
import 'package:I_Am_Tailor/locale/localInfo.dart';
import 'package:I_Am_Tailor/screens/homepage.dart';
import 'package:I_Am_Tailor/screens/status_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

DateTime timestamp = DateTime.now();

List todayData = [];

Future<bool> makeRequest(String _username, String _profile, LocalInfo localData,
    BuildContext context) async {
  bool success = false;
  var requestPath = db.collection("company/requests/requests");
  var userPath = db.collection("company/team/members");
  userPath.doc(localData.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            userPath.doc(localData.loginPhone).update(
                {"name": _username, "profile": _profile, "requestMade": true})
          }
        else
          {
            print("Check Needed, no user saved on cloud but request is sent"),
          }
      });
  requestPath.doc(localData.loginPhone).get().then((snapShot) async => {
        if (snapShot.exists)
          {
            print("Request already exists with this phone number"),
            localData.saveRequest()
          }
        else
          {
            requestPath.doc(localData.loginPhone).set({
              "phoneNo": localData.loginPhone,
              "username": _username,
              "requestProfile": _profile
            }),
            db
                .collection("company")
                .doc("requests")
                .update({"total": FieldValue.increment(1)}),
            print(localData.loginPhone),
            localData.saveDetails(_username, _profile),
            localData.saveRequest(),
            success = true,
            await Future.delayed(Duration(seconds: 1)),
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StatusPage()),
                (route) => false)
          }
      });
  await Future.delayed(Duration(seconds: 1));
  return success;
}

Future<bool> deleteRequest(LocalInfo localData) async {
  bool success = false;
  var requestPath = db.collection("company/requests/requests");
  var userPath = db.collection("company/team/members");
  userPath.doc(localData.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            userPath.doc(localData.loginPhone).update({
              "name": "",
              "profile": "",
              "requestMade": false,
            })
          }
        else
          {
            print(
                "Check Needed, no user saved on cloud but request is deleted"),
          }
      });
  requestPath.doc(localData.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            requestPath.doc(localData.loginPhone).delete(),
            db.collection("company").doc("requests").update(
              {"total": FieldValue.increment(-1)},
            ),
            localData.deleteDetails(),
            success = true,
          }
        else
          {print("There is no request with" + localData.loginPhone)}
      });
  await Future.delayed(Duration(seconds: 1));
  return success;
}

Future saveUserInfo(String phoneNo) async {
  var userPath = db.collection("company/team/members");
  userPath.doc(phoneNo).get().then((snapShot) => {
        if (snapShot.exists)
          {print("User Exists")}
        else
          {
            print("New User"),
            userPath.doc(phoneNo).set({
              "phoneNo": phoneNo,
              "requestAccepted": false,
              "name": "",
              "profile": "",
              "requestMade": false
            })
          }
      });
}

Future checkStatus(BuildContext context, LocalInfo localData) async {
  var userPath = db.collection("company/team/members");
  userPath.doc(localData.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            userPath.doc(localData.loginPhone).get().then((element) => {
                  if (element.data().containsKey("requestAccepted"))
                    {
                      if (element.data()["requestAccepted"] == true)
                        {
                          localData.saveRequestStatus(),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          )
                        }
                    }
                })
          }
        else
          {
            print("No user still request ???"),
          }
      });
}

Future getLocalDetails(LocalInfo localData) async {
  var userPath = db.collection("company/team/members");
  Map temp;
  userPath.doc(localData.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            print("User Exists"),
            userPath.doc(localData.loginPhone).get().then((element) => {
                  if (element.exists)
                    {
                      temp = element.data(),
                      if (temp.containsKey("requestAccepted") &&
                          temp["requestAccepted"])
                        localData.saveRequestStatus(),
                      if (temp.containsKey("requestMade") &&
                          temp["requestMade"])
                        localData.saveRequest(),
                      if (temp.containsKey("name") &&
                          temp.containsKey("profile") &&
                          temp["name"].length > 0 &&
                          temp["profile"].length > 0)
                        localData.saveDetails(temp["name"], temp["profile"]),
                    }
                }),
          }
        else
          {
            print("New User"),
          }
      });
  await Future.delayed(Duration(seconds: 2));
}
