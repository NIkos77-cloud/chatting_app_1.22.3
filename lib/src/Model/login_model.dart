import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String displayName;
  String email;
  String id;
  String photoUrl;
  double latitude;
  double longitude;
  String createdAt;

  UserModel(
      {this.displayName,
      this.email,
      this.id,
      this.photoUrl,
      this.latitude,
      this.createdAt,
      this.longitude});

  UserModel.fromJson(Map<String, dynamic> json) {
    displayName = json['name'];
    email = json['email'];
    id = json['uid'];
    photoUrl = json['photo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.displayName;
    data['email'] = this.email;
    data['uid'] = this.id;
    data['photo'] = this.photoUrl;
    data['latitude'] = this.latitude;
    data['longitude'] = this.latitude;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class AllUserModel {
  List<UserModel> users = [];

  AllUserModel.fromJson(List<DocumentSnapshot> docs) {
    for (DocumentSnapshot _doc in docs) {
      final Map user = _doc.data();
      user['id'] = _doc.id;
      users.add(UserModel.fromJson(user));
    }
  }
}
