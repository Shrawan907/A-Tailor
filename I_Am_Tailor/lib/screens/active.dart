import 'dart:async';
import 'package:I_Am_Tailor/locale/app_localization.dart';
import 'package:I_Am_Tailor/locale/localInfo.dart';
import 'package:flutter/material.dart';
import 'package:I_Am_Tailor/common/nav.drower.dart';
import 'package:I_Am_Tailor/common/cardBox.dart';
import 'package:I_Am_Tailor/handle_cloud/data_file.dart';
import 'package:flutter/services.dart';
import 'package:I_Am_Tailor/screens/on_working.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:I_Am_Tailor/common/cardBox.dart';

List items = [
  {"regNo": "123", "isComplete": true},
  {"regNo": "124", "isComplete": false},
  {"regNo": "127", "isComplete": true},
  {"regNo": "127", "isComplete": true},
  {"regNo": "127", "isComplete": true},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
];

class ActiveWork extends StatefulWidget {
  @override
  _ActiveWorkState createState() => _ActiveWorkState();
}

class _ActiveWorkState extends State<ActiveWork> {
  String profile = "";
  String name = "";
  String phoneNo = "";
  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() async {
    profile = LocalInfo.profile;
    name = LocalInfo.name;
    phoneNo = LocalInfo.loginPhone;
    await getData();
    setState(() {});
  }

  Future getData() async {
    items.clear();
    items = [...(await getActiveData(LocalInfo.loginPhone))];
    setState(() {});
  }

  onPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnWork()));
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("member_diary")),
        actions: [
          GestureDetector(
            onTap: getData,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            clearData();
            getData();
          } catch (err) {
            print(err);
          }
        },
        child: ListView(
          children: [
            InfoCard(
              name: this.name, //"Amitabh Ji",
              profile: this
                  .profile, //AppLocalizations.of(context).translate("shirt_maker"),
              phone: this.phoneNo,
              image: AssetImage("assets/images/person.png"),
            ),
            StickyHeader(
              header: buildHeader(this.profile, context),
              content: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    CardBox(
                      regNo: items[i]['regNo'],
                      type: items[i]["type"],
                      count: items[i]["count"],
                      profile: this.profile,
                      isColor: i & 1 == 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
