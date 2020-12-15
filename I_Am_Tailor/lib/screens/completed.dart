import 'dart:async';
import 'package:I_Am_Tailor/locale/app_localization.dart';
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StickyHeader(
              header: buildHeader("Shirt Maker", context),
              content: Column(
                children: [
                  for (int i = 0; i < items.length; i++)
                    ShirtCardBox(
                      regNo: items[i]['regNo'],
                      color: Colors.black,
                      type: items[i]['type'],
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
