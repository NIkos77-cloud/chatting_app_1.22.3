import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/src/Database/database_service.dart';
import 'package:chat_app/src/Helper/location_helper.dart';
import 'package:chat_app/src/Model/login_model.dart';
import 'package:chat_app/src/Views/Chat/chat_room.dart';
import 'package:chat_app/src/Views/Map/map_page.dart';
import 'package:chat_app/src/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final _database = DatabaseService();
  Position _position;

  @override
  void initState() {
    super.initState();
    _getCurrrentPosition();
  }

  Future<void> _getCurrrentPosition() async {
    _position = await LocationHelper.determinePosition();
    await _database.updateUser(
      Variables.user.id,
      {
        'latitude': _position.latitude,
        'longitude': _position.longitude,
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllUserModel>(
      future: _database.getAllUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitDoubleBounce(
              color: Variables.appColor,
              size: 20.0,
            ),
          );
        }
        final List<UserModel> _users = snapshot.data.users;
        return ListView.builder(
          itemCount: _users.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            return _users[index].id == Variables.user.id
                ? SizedBox()
                : _buildItem(_users[index], _users);
          },
        );
      },
    );
  }

  Widget _buildItem(UserModel user, List<UserModel> userList) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Chat(
              peerId: user.id,
              peerAvatar: user.photoUrl,
              peerName: user.displayName,
            ),
          ),
        );

        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => MapPage(position: _position, users: userList),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          children: [
            _leadingIcon(user),
            _titleAndSubTitle(user),
          ],
        ),
      ),
    );
  }

  Widget _leadingIcon(UserModel user) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.indigo[100],
            blurRadius: 10.0,
            offset: Offset(4, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: user.photoUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => Center(
            child: SpinKitPulse(
              color: Variables.appColor,
              size: 10,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            padding: EdgeInsets.all(13),
            child: Image.asset(
              'assets/images/user.png',
              color: Variables.appColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleAndSubTitle(UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(user),
          _status(user),
        ],
      ),
    );
  }

  Widget _title(UserModel user) {
    return Container(
      child: Text(user.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _status(UserModel user) {
    return Container(
      child: Text(
        'No Status',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
