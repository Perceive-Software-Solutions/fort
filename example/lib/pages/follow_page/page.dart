import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fort_example/api/mock_api.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/concrete_fort.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

part 'state.dart';
part 'follow_tile.dart';

class FollowPage extends StatefulWidget {
  FollowPage({ Key? key }) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  
  ///Store
  final Store<FollowPageState> followPageStore = Store<FollowPageState>(
    followPageReducer,
    initialState: FollowPageState.innitial(),
    middleware: [thunkMiddleware]
  );

  @override
  void initState(){
    super.initState();
    
    Future.delayed(const Duration(seconds: 1)).then((value){
      followPageStore.dispatch(LoadUsersEvent);
    });
  }

  Widget userList(BuildContext context, List<String> userIDs){
    return ListView.builder(
      itemCount: userIDs.length,
      itemBuilder: (context, index) {
        return FollowTile(userID: userIDs[index],);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<FollowPageState>(
      store: followPageStore,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Follow Page"),
        ),
        body: Center(
          child: StoreConnector<FollowPageState, FollowPageState>(
            converter: (store) => store.state,
            builder: (context, state) {
              
              if(state.loadState == LoadState.LOADED){
                //List of users
                return userList(context, state.userIDs);
              }
              else if(state.loadState == LoadState.ERROR){
                //Error Message
                return Text(state.errorMessage ?? "Error", style: const TextStyle(color: Colors.red),);
              }
              else{
                //Loading symbol
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}