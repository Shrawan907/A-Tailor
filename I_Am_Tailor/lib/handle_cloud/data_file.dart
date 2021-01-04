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

List activeData = [];
List completedData = [];
List tempData = [[], []];
List reqData = [];

Future<List> fetchData(String phoneNo) async {
  tempData.clear();
  tempData = [[], []];
  var dataPath = db.collection("company/team/members/$phoneNo/assigned");
  // print(phoneNo);
  dataPath.snapshots().listen((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      Map temp = element.data();
      print(temp);
      if (temp["isComplete"]) {
        tempData[1].addAll([
          {
            'regNo': temp["reg_no"],
            'type': temp["type"],
            'count': temp["count"]
          }
        ]);
      } else {
        tempData[0].addAll([
          {
            'regNo': temp["reg_no"],
            'type': temp["type"],
            'count': temp["count"]
          }
        ]);
      }
    });
  });
  await Future.delayed(Duration(seconds: 2));
  return tempData;
}

void clearData() {
  activeData.clear();
  completedData.clear();
}

Future<List> getActiveData(String phoneNo) async {
  if (activeData == null || activeData.isEmpty) {
    List temp = await fetchData(phoneNo);
    activeData = [...(temp[0])];
    completedData.clear();
    completedData = [...(temp[1])];
    return activeData;
  } else {
    return activeData;
  }
}

Future<List> getCompletedData(String phoneNo) async {
  if (completedData == null || completedData.isEmpty) {
    List temp = await fetchData(phoneNo);
    completedData = [...(temp[1])];
    activeData.clear();
    activeData = [...(temp[0])];
    return completedData;
  }
  return completedData;
}

Future<bool> makeRequest(String _username, String _profile, LocalInfo localData,
    BuildContext context) async {
  bool success = false;
  var requestPath = db.collection("company/requests/requests");
  var userPath = db.collection("company/team/members");
  userPath.doc(LocalInfo.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            userPath.doc(LocalInfo.loginPhone).update(
                {"name": _username, "profile": _profile, "requestMade": true})
          }
        else
          {
            print("Check Needed, no user saved on cloud but request is sent"),
          }
      });
  requestPath.doc(LocalInfo.loginPhone).get().then((snapShot) async => {
        if (snapShot.exists)
          {
            print("Request already exists with this phone number"),
            localData.saveRequest()
          }
        else
          {
            requestPath.doc(LocalInfo.loginPhone).set({
              "phoneNo": LocalInfo.loginPhone,
              "username": _username,
              "requestProfile": _profile
            }),
            db
                .collection("company")
                .doc("requests")
                .update({"total": FieldValue.increment(1)}),
            print(LocalInfo.loginPhone),
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
  userPath.doc(LocalInfo.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            userPath.doc(LocalInfo.loginPhone).update({
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
  requestPath.doc(LocalInfo.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            requestPath.doc(LocalInfo.loginPhone).delete(),
            db.collection("company").doc("requests").update(
              {"total": FieldValue.increment(-1)},
            ),
            localData.deleteDetails(),
            success = true,
          }
        else
          {
            print("There is no request with" + LocalInfo.loginPhone),
          }
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
  userPath.doc(LocalInfo.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            userPath.doc(LocalInfo.loginPhone).get().then((element) => {
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
  userPath.doc(LocalInfo.loginPhone).get().then((snapShot) => {
        if (snapShot.exists)
          {
            print("User Exists"),
            userPath.doc(LocalInfo.loginPhone).get().then((element) => {
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

Future<List> fetchRequestData(String phone) async {
  tempData.clear();
  var membersPath = db.collection("company/team/members");
  membersPath.snapshots().listen((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      Map temp = element.data();
      // print(temp);
      if (temp.containsKey("phoneNo") && temp["phoneNo"] == phone) {
        tempData.addAll([
          {
            "requestMade": temp["requestMade"],
            "requestAccepted": temp["requestAccepted"]
          }
        ]);
        // print("////////////////");
        // print(tempData);
        // print("////////////////");
      }
    });
  });
  await Future.delayed(Duration(seconds: 2));
  print(tempData);
  // print("//// $phone /////");
  return tempData;
}

Future<List> getRequestData(String phone) async {
  reqData.clear();
  // reqData.clear();
  reqData = [...(await fetchRequestData(phone))];
  // print(reqData);
  return reqData;
}

Future<void> deleteUser(String phone) {
  CollectionReference users = FirebaseFirestore.instance.collection('company/team/members');
  return users
      .doc(phone)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}

// bool requestAccepted(){
//   return
// }
