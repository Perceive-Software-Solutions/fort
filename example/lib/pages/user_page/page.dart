import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fort_example/api/mock_api.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/concrete_fort.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserPage extends StatelessWidget {

  ///User ID for the user
  final String userID;

  const UserPage({ Key? key, required this.userID }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserID: $userID"),
      ),
      body: Center(
        child: ValueListenableBuilder<Box<User>>(
          valueListenable: ConcreteFort().getStoreListener(FortKey.USER_KEY, [userID]),
          builder: (context, userBox, child) {
            User? user = userBox.get(userID);

            if(user == null){
              return const CircularProgressIndicator();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  Text(user.name ?? "", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),

                  const Spacer(),

                  Container(
                    color: Colors.blue,
                    height: 60,
                    width: 100,
                    child: Center(
                      child: TextButton(
                        child: const Icon(Icons.add, color: Colors.white),
                        onPressed: (){
                          Api.addFollower(userID);
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
                          Api.removeFollower(userID);
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
    );
  }
}