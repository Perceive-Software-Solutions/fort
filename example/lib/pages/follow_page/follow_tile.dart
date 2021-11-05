
part of 'page.dart';

class FollowTile extends StatefulWidget {

  final String userID;

  const FollowTile({ Key? key, required this.userID }) : super(key: key);

  @override
  State<FollowTile> createState() => _FollowTileState();
}

class _FollowTileState extends State<FollowTile> {

  late final UserKeep keep = UserKeep(widget.userID);

  Widget roundButton(BuildContext contex, {required IconData icon, required Color color, required Function() onTap}){
      return GestureDetector(
        child: Container(
            height: 30,
            width: 30,
            child: Center(child: Icon(icon, color: Colors.white,)),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
            ),
          ),
          onTap: onTap,
      );
  }

  Widget buildFollowButtons(BuildContext context, int followers){

    return SizedBox(
      width: 150,
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          roundButton(
              context, 
              icon: Icons.minimize, 
              color: Colors.red, 
              onTap: (){
                Api.removeFollower(widget.userID);
              }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text("$followers", style: const TextStyle(fontWeight: FontWeight.bold),),
          ),
          roundButton(
              context, 
              icon: Icons.add, 
              color: Colors.blue, 
              onTap: (){
                Api.addFollower(widget.userID);
              }
          ),
        ],
      ),
    );
  }

  Widget buildTile(BuildContext context, User? user){
    if(user == null){
        return const Center(
            child: CircularProgressIndicator()
        );
    }

    return ListTile(
      title: Text("UserID: ${user.id}"),
      subtitle: StoreConnector<UserKeepState, UserKeepState>(
        converter: (store) => store.state,
        builder: (context, state) {

          Color textColor = state.state == HydratedKeepStates.DEACTIVE ? Colors.grey[600]! : Colors.blue;

          return Text(state.hydrate ?? "Hydrating...", style: TextStyle(color: textColor),);
        }
      ),
      trailing: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildFollowButtons(context, user.follows ?? 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: keep,
      child: Card(
        elevation: 1,
        color: Colors.yellow[50],
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