import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:I_Am_Tailor/locale/localInfo.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future handleSignIn(GoogleSignInAccount account, BuildContext context) async {
    var log = Provider.of<LocalInfo>(context, listen: false);
    if (account != null) {
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      print("\nsigned in " + user.displayName + "\n");

      log.changeStatustoLogin();

      return user;
    }
  }

  logout(BuildContext context) async {
    var log = Provider.of<LocalInfo>(context, listen: false);
    log.changeStatustoLogout();
    googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
