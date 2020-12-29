import 'package:I_Am_Tailor/locale/app_localization.dart';
import 'package:I_Am_Tailor/screens/make_request.dart';
import 'package:I_Am_Tailor/screens/on_working.dart';
import 'package:I_Am_Tailor/screens/status_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:I_Am_Tailor/locale/localInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:I_Am_Tailor/screens/registration_screen.dart';
import 'package:I_Am_Tailor/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalInfo localData = LocalInfo();
  await localData.fetchLocale();
  await localData.fetchLocalDetail();
  print(" XXXX " + LocalInfo.loggedIn.toString());
  print("request: " + LocalInfo.requestMade.toString());
  runApp(MyApp(
    localData: localData,
  ));
}

class MyApp extends StatelessWidget {
  final LocalInfo localData;
  MyApp({this.localData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocalInfo>(
      create: (_) => localData,
      child: Consumer<LocalInfo>(builder: (context, model, child) {
        return MaterialApp(
            locale: model.appLocal,
            debugShowCheckedModeBanner: false,
            supportedLocales: [
              Locale('en', ''),
              Locale('hi', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.amber,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                accentColor: Colors.grey),
            home: (LocalInfo.loggedIn == false
                ? MyHomePage(
                    title:
                        "I AM TAILOR", //AppLocalizations.of(context).translate("welcom_aap_name"),
                  )
                : LocalInfo.requestMade == false
                    ? RequestPage()
                    : LocalInfo.requestAccepted == false
                        ? StatusPage()
                        : HomePage()));
      }),
    );
  }
}

// For Localization (Multiple Language)
// https://medium.com/flutter-community/flutter-internationalization-the-easy-way-using-provider-and-json-c47caa4212b2
