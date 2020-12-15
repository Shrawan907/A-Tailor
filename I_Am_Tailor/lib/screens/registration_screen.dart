import 'package:I_Am_Tailor/locale/app_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:I_Am_Tailor/handle_cloud/login.dart';
import 'package:I_Am_Tailor/common/nav.drower.dart';
// import 'package:I_Am_Tailor/test_screen.dart';
import 'package:I_Am_Tailor/screens/homepage.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User currentUser;
  bool isAuth = false;
  Authenticate _authenticate = Authenticate();

  @override
  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((account) async {
      currentUser = await _authenticate.handleSignIn(account, context);
      setState(() {
        if (currentUser == null)
          isAuth = false;
        else
          isAuth = true;
      });
    }).onError((err) {
      print("Sign in error: $err");
    });
    // googleSignIn.signInSilently(suppressErrors: false).then((account) async {
    //   currentUser = await _authenticate.handleSignIn(account, context);

    //   setState(() {
    //     if (currentUser == null)
    //       isAuth = false;
    //     else
    //       isAuth = true;
    //   });
    // }).catchError((err) {
    //   print("Error signing in silently: $err");
    // });

    print("\n Current User $currentUser \n");
  }

  Scaffold buildUnAuthScreen(BuildContext context) {
    return Scaffold(
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
            GestureDetector(
              onTap: () {
                _authenticate.login(context);
              },
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold buildAuthScreen(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate("t_create_join_company")),
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
        child: Center(
          child: SizedBox(
            width: 180,
            height: 50,
            child: RaisedButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => TestScreen()));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text(
                AppLocalizations.of(context).translate("join_company"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.white),
              ),
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen(context) : buildUnAuthScreen(context);
  }
}
