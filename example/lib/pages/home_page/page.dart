import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fort_example/components/user_tile.dart';
import 'package:fort_example/pages/follow_page/page.dart';
import 'package:fort_example/api/mock_api.dart';
import 'package:fort_example/models/user.dart';
import 'package:fort_example/state/concrete_fort.dart';
import 'package:fort_example/state/fort_keys.dart';
import 'package:hive/hive.dart';
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
  final Store<HomePageState> homePageStore = Store<HomePageState>(
    homePageReducer,
    initialState: HomePageState.innitial(),
    middleware: [thunkMiddleware]
  );

  @override
  void initState(){
    super.initState();
    
    Future.delayed(const Duration(seconds: 1)).then((value){
      homePageStore.dispatch(LoadUsersEvent);
    });
  }

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
      ),
    );
  }
}