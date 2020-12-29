import 'package:I_Am_Tailor/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class InfoCard extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final String phone;
  final String profile;
  InfoCard({this.name, this.profile, this.phone, this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150,
        color: Colors.black12,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 135,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: image,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        profile,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        Text(
                          " " + phone,
                          style:
                              TextStyle(fontSize: 20, color: Colors.blue[700]),
                        ),
                      ],
                    ),
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

class CardBox extends StatelessWidget {
  final int regNo;
  final int count;
  final String type;
  final bool isColor;
  final String profile;

  const CardBox(
      {this.regNo, this.count, this.type, this.isColor, this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isColor ? Colors.grey[200] : null,
      borderOnForeground: true,
      child: Container(
        height: 25,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: (profile == "SHIRT MAKER")
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '$regNo',
                      style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black54),
                    ),
                  ),
                  Expanded(
                    child: type == "safari"
                        ? Text("$count",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54))
                        : Text(""),
                  ),
                  Expanded(
                    child: type == "kurta"
                        ? Text("$count",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54))
                        : Text(""),
                  ),
                  Expanded(
                    child: type == "pajama"
                        ? Text("$count",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54))
                        : Text(""),
                  ),
                  Expanded(
                    child: type == "shirt"
                        ? Text("$count",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black54))
                        : Text(""),
                  ),
                ],
              )
            : (profile == "PENT MAKER")
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '$regNo',
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        child: type == "pent"
                            ? Text("$count",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54))
                            : Text(""),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '$regNo',
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        child: type == "coat"
                            ? Text("$count",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54))
                            : Text(""),
                      ),
                      Expanded(
                        child: type == "achkan"
                            ? Text("$count",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54))
                            : Text(""),
                      ),
                    ],
                  ),
      ),
    );
  }
}

Card buildHeader(String headerType, BuildContext context) {
  if (headerType == "dailyInfo") {
    return Card(
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.cyan,
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
        padding: EdgeInsets.only(left: 30, right: 0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                AppLocalizations.of(context).translate("reg_no"),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              )),
              Expanded(
                  child: Text(
                AppLocalizations.of(context).translate("coat"),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              )),
              Expanded(
                  child: Text(
                "     " + AppLocalizations.of(context).translate("complete"),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ))
            ],
          ),
        ),
      ),
    );
  } else if (headerType == "SHIRT MAKER") {
    return Card(
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).translate("reg_no"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              AppLocalizations.of(context).translate("safari"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            )),
            Expanded(
                child: Text(
              AppLocalizations.of(context).translate("kurta"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            )),
            Expanded(
                child: Text(
              AppLocalizations.of(context).translate("pajama"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            )),
            Expanded(
                child: Text(
              "   " + AppLocalizations.of(context).translate("shirt"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            )),
            // Expanded(
            //     child: Text(
            //   AppLocalizations.of(context).translate("complete"),
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 15,
            //       color: Colors.white),
            // ))
          ],
        ),
      ),
    );
  } else {
    return Card(
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).translate("reg_no"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}
