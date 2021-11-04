import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fort/fort.dart';
import 'package:fort_example/components/user_tile.dart';
import 'package:fort_example/pages/follow_page/page.dart';
import 'package:fort_example/api/mock_api.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:hive/hive.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

part 'state.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  ///Store
  late final Tower<HomePageState> homePageStore = Tower<HomePageState>(
    homePageReducer,
    initialState: HomePageState.innitial(),
    serializer: HomePageState.fromJson
  );

  Widget userList(BuildContext context, List<String> userIDs){
    return ListView.builder(
      itemCount: userIDs.length,
      itemBuilder: (context, index) {
        return UserTile(userID: userIDs[index],);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<HomePageState>(
      store: homePageStore,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Follow Page"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white,),
              onPressed: (){
                homePageStore.dispatch(LoadUsersEvent);
              },
            )
          ],
        ),
        body: Center(
          child: StoreConnector<HomePageState, HomePageState>(
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Api.reloadState();
          },
        ),
      ),
    );
  }
}