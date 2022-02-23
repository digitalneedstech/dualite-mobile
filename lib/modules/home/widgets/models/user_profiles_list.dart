
import 'package:dualites/models/user_profile_model.dart';

class UserProfilesList{
  int count;
  String next;
  List<UserProfileModel> results;
  UserProfilesList({this.next,this.count,this.results});
  factory UserProfilesList.fromMap(Map<String,dynamic> json){
    return new UserProfilesList(
        next: json['next'] as String,
        count: json['count'] as int,
        results: json['results']==null ? []:(json['results'] as List)
        ?.map((e) => e == null ? null : UserProfileModel.fromMap(Map.from(e)))
        ?.toList()
    );
  }
}