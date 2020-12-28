import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LocalInfo extends ChangeNotifier {
  Locale _appLocale = Locale('en');
  bool loggedIn = false;
  String loginPhone;
  bool requestMade = false;
  bool requestAccepted = false;
  String name = "";
  String profile = "";

// this is call when request is accepted by admin
  saveRequestStatus() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("${loginPhone}_requestAccepted", true);
    requestAccepted = true;
    notifyListeners();
  }

// this is call when request is deleted by admin
  removeRequestStatus() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("${loginPhone}_requestAccepted"))
      prefs.remove("${loginPhone}_requestAccepted");
    notifyListeners();
  }

// give the value of requestAccepted
  fetchRequestStatus() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("${loginPhone}_requestAccepted") &&
        prefs.getBool("${loginPhone}_requestAccepted") == true)
      this.requestMade = true;
    else
      this.requestMade = false;
    return Null;
  }

// this is called if request is made
  saveRequest() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("${loginPhone}_requestMade", true);
    requestMade = true;
    notifyListeners();
  }

// this is called if request is deleted
  removeRequest() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("${loginPhone}_requestMade"))
      prefs.remove("${loginPhone}_requestMade");
    requestMade = false;
    notifyListeners();
  }

// this is called if user logged in with phone number
  savePhoneNo(String phoneNo) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('loginPhone', phoneNo);
    loginPhone = phoneNo;
    notifyListeners();
  }

// this is called if user log out
  removePhoneNo() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("loginPhone")) prefs.remove("loginPhone");
    loginPhone = null;
    requestMade = false;
    requestAccepted = false;
    notifyListeners();
  }

// this is called if request is made
  saveDetails(String name, String profile) async {
    var prefs = await SharedPreferences.getInstance();
    this.name = name;
    this.profile = profile;
    prefs.setString("${loginPhone}_name", name);
    prefs.setString("${loginPhone}_profile", profile);
    notifyListeners();
  }

// this is called if request is deleted
  deleteDetails() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("${loginPhone}_name")) {
      prefs.remove("${loginPhone}_name");
      name = "";
    }
    if (prefs.containsKey("${loginPhone}_profile")) {
      prefs.remove("${loginPhone}_profile");
      profile = "";
    }
    if (prefs.containsKey("${loginPhone}_requestMade")) {
      prefs.remove("${loginPhone}_requestMade");
      requestMade = false;
    }
    notifyListeners();
  }

// this give all saved info of current user
  fetchLocalDetail() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("loggedIn")) loggedIn = prefs.getBool("loggedIn");

    if (prefs.containsKey("loginPhone"))
      loginPhone = prefs.getString("loginPhone");

    if (prefs.containsKey("${loginPhone}_requestMade"))
      requestMade = prefs.getBool("${loginPhone}_requestMade");

    if (prefs.containsKey("${loginPhone}_requestAccepted"))
      requestAccepted = prefs.getBool("${loginPhone}_requestAccepted");

    if (prefs.containsKey("${loginPhone}_name"))
      name = prefs.getString("${loginPhone}_name");

    if (prefs.containsKey("${loginPhone}_profile"))
      profile = prefs.getString("${loginPhone}_profile");

    return null;
  }

// this is called if user is logged in
  changeStatustoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("loggedIn", true);
    loggedIn = true;
    notifyListeners();
  }

// this is called if user if logged out
  changeStatustoLogout() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("loggedIn")) prefs.remove("loggedIn");
    loggedIn = false;
    notifyListeners();
  }

  Locale get appLocal {
    if (this._appLocale == Locale('hi')) {
      return Locale('hi');
    } else {
      return Locale('en');
    }
  }

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      this._appLocale = Locale('en');
      return Null;
    }
    this._appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (this._appLocale == type) {
      return;
    }
    if (type == Locale("hi")) {
      this._appLocale = Locale("hi");
      await prefs.setString('language_code', 'hi');
      await prefs.setString('countryCode', '');
      print(this._appLocale);
    } else {
      this._appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', '');
      print(this._appLocale);
    }
    notifyListeners();
  }
}
