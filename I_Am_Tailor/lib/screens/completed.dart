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
import 'package:sticky_headers/sticky_headers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:I_Am_Tailor/common/cardBox.dart';

List items = [
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
  {"regNo": "123", "type": "pajama", "isComplete": true},
  {"regNo": "124", "type": "shirt", "isComplete": false},
  {"regNo": "127", "type": "kurta", "isComplete": true},
  {"regNo": "127", "type": "shirt", "isComplete": true},
];

class CompletedWork extends StatefulWidget {
  @override
  _CompletedWorkState createState() => _CompletedWorkState();
}

class _CompletedWorkState extends State<CompletedWork> {
  String profile = "";

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() async {
    profile = LocalInfo.profile;
    await getData();
  }

  Future getData() async {
    items.clear();
    items = [...(await getCompletedData(LocalInfo.loginPhone))];
    setState(() {});
  }

  onPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnWork()));
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
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
            StickyHeader(
              header: buildHeader("SHIRT MAKER", context),
              content: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    CardBox(
                      regNo: items[i]['regNo'],
                      count: items[i]["count"],
                      type: items[i]['type'],
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
