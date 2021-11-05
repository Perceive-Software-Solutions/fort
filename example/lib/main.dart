import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:fort_example/models/hydrated_keep_state.dart';

import 'package:fort_example/models/user.dart';
import 'package:fort_example/pages/follow_page/page.dart';
import 'package:fort_example/pages/home_page/page.dart';
import 'package:fort_example/state/fort_keys.dart';

void main() async {
  await Fort().register(FortKey.USER_KEY, UserAdapter());
  Fort().registerAdapter(HydratedKeepStatesAdapter());
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
