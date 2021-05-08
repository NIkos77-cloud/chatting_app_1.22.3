import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/src/Model/login_model.dart';
import 'package:chat_app/src/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'marker_generator.dart';

class MapPage extends StatefulWidget {
  const MapPage({@required this.position, @required this.users});
  final List<UserModel> users;
  final Position position;
  @override
  _MapPageState createState() => _MapPageState(position, users);
}

class _MapPageState extends State<MapPage> {
  _MapPageState(this.position, this.users);
  final Position position;
  final List<UserModel> users;
  List<Marker> markers = [];

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    MarkerGenerator(markerWidgets(), (bitmaps) {
      setState(() {
        markers = mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);
    setState(() {});
  }

  List<Marker> mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    List<Marker> markersList = [];
    bitmaps.asMap().forEach((i, bmp) {
      final _user = users[i];
      markersList.add(
        Marker(
          markerId: MarkerId(_user.id),
          position: LatLng(_user.latitude, _user.longitude),
          icon: BitmapDescriptor.fromBytes(bmp),
        ),
      );
    });
    return markersList;
  }

  Widget _getMarkerWidget(UserModel user) {
    return Container(
        height: 150,
        width: 90,
        // color: Colors.red,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.red,
        //   shape: BoxShape.rectangle,
        // ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(user.photoUrl),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo[100],
                    blurRadius: 10.0,
                    offset: Offset(4, 5),
                  ),
                ],
              ),
              child: Text(
                user.displayName.split(' ')[0].capitalize(),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        )
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(8),
        //   child: CachedNetworkImage(
        //     imageUrl: photoUrl,
        //     imageBuilder: (context, imageProvider) => Container(
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: imageProvider,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //     placeholder: (context, url) => Center(
        //       child: SpinKitPulse(
        //         color: Variables.appColor,
        //         size: 10,
        //       ),
        //     ),
        //     errorWidget: (context, url, error) => Container(
        //       padding: EdgeInsets.all(13),
        //       child: Image.asset(
        //         'assets/images/user.png',
        //         color: Variables.appColor,
        //       ),
        //     ),
        //   ),
        // ),
        );
  }

  List<Widget> markerWidgets() {
    return users.map((c) => _getMarkerWidget(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        backgroundColor: Variables.appColor,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markers.toSet(),
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
