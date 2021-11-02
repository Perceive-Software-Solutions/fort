import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fort/fort.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/pages/follow_page/page.dart';
import 'package:fort_example/pages/home_page/page.dart';
import 'package:fort_example/state/concrete_fort.dart';
import 'package:fort_example/state/fort_keys.dart';

void main() {
  ConcreteFort().register(FortKey.USER_KEY, UserAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: IndexedStack(
          index: index,
          children: [
            HomePage(),
            FollowPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Follow",
            ),
          ],
        ),
      ),
    );
  }
}
