import 'package:I_Am_Tailor/screens/on_working.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:I_Am_Tailor/screens/active.dart';
import 'package:I_Am_Tailor/screens/completed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          ActiveWork(),
          CompletedWork(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          home: CupertinoTabBar(
            backgroundColor: Colors.white,
            currentIndex: pageIndex,
            onTap: onTap,
            activeColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.whatshot),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
