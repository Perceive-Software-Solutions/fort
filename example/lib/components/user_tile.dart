

import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/pages/user_page/page.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserTile extends StatelessWidget {

  final String userID;

  const UserTile({ Key? key, required this.userID }) : super(key: key);

  Widget buildTile(BuildContext context, User? user){
    if(user == null){
        return const Center(
            child: CircularProgressIndicator()
        );
    }

    return ListTile(
      title: Text("${user.name}", style: const TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text("UserID: ${user.id}", style: TextStyle(color: Colors.grey[400]),),
      trailing: Text("Followers: ${user.follows ?? 0}", style: const TextStyle(color: Colors.red),),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return UserPage(userID: userID);
        },));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.green[50],
      child: ValueListenableBuilder<Box<User>>(
        valueListenable: Fort().getStoreListener(FortKey.USER_KEY, [userID]),
        builder: (context, box, child) {
          User? user = box.get(userID);
          return buildTile(context, user);
        },
      ),
    );
  }
}