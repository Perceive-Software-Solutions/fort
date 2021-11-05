import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fort/fort.dart';
import 'package:fort_example/api/mock_api.dart';
import 'package:fort_example/models/hydrated_keep_state.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:fort_example/state/user_keep/state.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserPage extends StatefulWidget {

  ///User ID for the user
  final String userID;

  const UserPage({ Key? key, required this.userID }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  late final UserKeep keep = UserKeep(widget.userID);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: keep,
      child: Scaffold(
        appBar: AppBar(
          title: Text("UserID: ${widget.userID}"),
        ),
        body: Center(
          child: ValueListenableBuilder<Box<User>>(
            valueListenable: Fort().getStoreListener(FortKey.USER_KEY, [widget.userID]),
            builder: (context, userBox, child) {
              User? user = userBox.get(widget.userID);

              if(user == null){
                return const CircularProgressIndicator();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    Text(user.name ?? "", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),

                    StoreConnector<UserKeepState, UserKeepState>(
                      converter: (store) => store.state,
                      builder: (context, state) {

                        Color textColor = state.state == HydratedKeepStates.DEACTIVE ? Colors.grey[600]! : Colors.blue;

                        return Text(state.hydrate ?? "Hydrating...", style: TextStyle(color: textColor),);
                      }
                    ),

                    const Spacer(),

                    Container(
                      color: Colors.blue,
                      height: 60,
                      width: 100,
                      child: Center(
                        child: TextButton(
                          child: const Icon(Icons.add, color: Colors.white),
                          onPressed: (){
                            Api.addFollower(widget.userID);
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 60,
                        width: 200,
                        color: Colors.grey[200],
                        child: Center(child: Text("${user.follows ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ),


                    Container(
                      color: Colors.red,
                      height: 60,
                      width: 100,
                      child: Center(
                        child: TextButton(
                          child: const Icon(Icons.remove, color: Colors.white),
                          onPressed: (){
                            Api.removeFollower(widget.userID);
                          },
                        ),
                      ),
                    ),


                    const Spacer(),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}