

import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:fort_example/models/hydrated_keep_state.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/pages/user_page/page.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:fort_example/state/user_keep/state.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserTile extends StatefulWidget {

  final String userID;

  const UserTile({ Key? key, required this.userID }) : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {

  late final UserKeep keep = UserKeep(widget.userID);

  Widget buildTile(BuildContext context, User? user){
    if(user == null){
        return const Center(
            child: CircularProgressIndicator()
        );
    }

    return ListTile(
      title: Text("${user.name}", style: const TextStyle(fontWeight: FontWeight.bold),),
      leading: Text("UserID: ${user.id}", style: TextStyle(color: Colors.grey[400]),),
      trailing: Text("Followers: ${user.follows ?? 0}", style: const TextStyle(color: Colors.red),),
      subtitle: StoreConnector<UserKeepState, UserKeepState>(
        converter: (store) => store.state,
        builder: (context, state) {

          Color textColor = state.state == HydratedKeepStates.DEACTIVE ? Colors.grey[600]! : Colors.blue;

          return Text(state.hydrate ?? "Hydrating...", style: TextStyle(color: textColor),);
        }
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return UserPage(userID: widget.userID);
        },));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<UserKeepState>(
      store: keep,
      child: Card(
        elevation: 1,
        color: Colors.green[50],
        child: ValueListenableBuilder<Box<User>>(
          valueListenable: Fort().getStoreListener(FortKey.USER_KEY, [widget.userID]),
          builder: (context, box, child) {
            User? user = box.get(widget.userID);
            return buildTile(context, user);
          },
        ),
      ),
    );
  }
}