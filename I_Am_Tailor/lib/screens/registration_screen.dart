import 'dart:async';
import 'package:I_Am_Tailor/handle_cloud/data_file.dart';
import 'package:I_Am_Tailor/locale/localInfo.dart';
import 'package:I_Am_Tailor/screens/make_request.dart';
import 'package:I_Am_Tailor/screens/on_working.dart';
import 'package:I_Am_Tailor/screens/status_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:I_Am_Tailor/screens/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String verId;
  String phoneNo;
  String smsCode;
  String verificationId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future mustDoBeforeSignin(LocalInfo log) async {
    log.savePhoneNo(this.phoneNo);
    await saveUserInfo(phoneNo);
    await Future.delayed(Duration(seconds: 1));
    await getLocalDetails(log);
    log.changeStatustoLogin();
    log.fetchLocalDetail();
  }

  Future<void> veifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetriveal = (String verId) {
      this.verificationId = verId;
    };
    final smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {});
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) async {
      print("verified\n");
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User user = result.user;
      if (user != null) {
        LocalInfo log = Provider.of<LocalInfo>(context, listen: false);
        await mustDoBeforeSignin(log);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => (LocalInfo.requestMade
                  ? (LocalInfo.requestAccepted ? HomePage() : StatusPage())
                  : RequestPage()),
            ),
            (route) => false);
      } else {
        print("Error ho gay bhai!");
      }
    };
    final PhoneVerificationFailed veriFailed =
        (FirebaseAuthException exception) {
      print("phone verification failed!");
      print("${exception.message}");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetriveal,
      timeout: const Duration(seconds: 5),
      codeSent: smsCodeSent,
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter Code: '),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Submit'),
                onPressed: () async {
                  smsCode = this.smsCode.trim();
                  try {
                    AuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsCode);
                    UserCredential result = await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    User user = result.user;
                    print(user);
                    if (user != null) {
                      var log = Provider.of<LocalInfo>(context, listen: false);
                      await mustDoBeforeSignin(log);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (LocalInfo.requestMade
                                ? (LocalInfo.requestAccepted
                                    ? HomePage()
                                    : StatusPage())
                                : RequestPage()),
                          ),
                          (route) => false);
                    } else {
                      print("\n ho gayi error yha\n");
                      Navigator.pop(context);
                    }
                  } catch (err) {
                    print(err);
                    SnackBar snackBar = SnackBar(content: Text("Wrong OTP !"));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                    Timer(Duration(seconds: 1), () {});
                  }
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("I Am Tailor"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 48.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              width: 400,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "+91",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        this.phoneNo = value;
                      },
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              //margin: EdgeInsets.only(left: 50, right: 50),
              width: 150,
              child: RaisedButton(
                color: Colors.amber,
                child: Text(
                  'Log In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (this.phoneNo.length != 10) {
                    SnackBar snackBar =
                        SnackBar(content: Text("Phone Number is Invalid!"));
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                    Timer(Duration(seconds: 1), () {});
                    return;
                  }
                  // print(phoneNo+"/////////////");
                  this.phoneNo = ("+91" + this.phoneNo).trim();
                  // print(this.phoneNo = ("+91" + this.phoneNo).trim()+"/////////////");
                  // print(phoneNo+"/////////////");
                  veifyPhone();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
