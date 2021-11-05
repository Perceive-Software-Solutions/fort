import 'package:fort/fort.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends KeepObject{

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? id;

  @HiveField(2)
  int? follows;

  @override
  @HiveField(3)
  dynamic hydratedStateKey;

  factory User() => User._(id: '');

  User._({
    this.id,
    this.name,
    this.follows,
    dynamic hydratedStateKey
  }) : assert(id != null), super(hydratedStateKey: hydratedStateKey);

  static User fromJson(Map<String, dynamic> json){

    String id = json['id'];
    String name = json['name'] ?? "";
    int follows = json['follows'] ?? 0;

    return User._(
      id: id,
      name: name,
      follows: follows
    );

  }

}