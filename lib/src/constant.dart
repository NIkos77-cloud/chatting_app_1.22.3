import 'package:chat_app/src/Model/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Variables {
  static const Color appColor = Colors.indigo;
  static SharedPreferences prefs;
  static UserModel user;
  static String defaultImage =
      'https://firebasestorage.googleapis.com/v0/b/chat-app-c8c1b.appspot.com/o/DefaultImage%2Fuser.png?alt=media&token=054b4ac9-1612-478b-a00d-efc8fbedfca9';
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    @required this.icon,
    @required this.titleText,
    @required this.hintText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.onSubmitted,
  });

  final Widget icon;
  final String titleText;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _title(),
          _textField(),
        ],
      ),
    );
  }

  Widget _title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _icon(),
        _titleText(),
      ],
    );
  }

  Widget _icon() => Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: icon,
      );

  Widget _titleText() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Text(
        titleText + '*',
        style: TextStyle(fontSize: 13.0, color: Variables.appColor),
      ),
    );
  }

  Widget _textField() {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
        border: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Variables.appColor),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {this.onPressed,
      this.animationDuration,
      this.child,
      this.radius = 6,
      this.color,
      this.elevation,
      this.height,
      this.minWidth});

  final Function onPressed;
  final Duration animationDuration;
  final double height;
  final double minWidth;
  final Widget child;
  final double radius;
  final Color color;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 45,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        onPressed: onPressed,
        animationDuration: animationDuration,
        color: color ?? Variables.appColor,
        // height: height,
        // minWidth: minWidth,
        child: child,
        autofocus: false,
        elevation: elevation,
      ),
    );
  }
}

class Indicators {
  ///default size is 20
  Widget indicatorWidget({
    double size = 20.0,
    Color color,
  }) {
    final Widget indicator = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitThreeBounce(
          color: Variables.appColor,
          size: size,
        ),
        Text(
          'Please Wait',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );

    return indicator;
  }

  dynamic indicatorPopupWillNotPop(BuildContext context,
      {bool barrierDismissible = false}) {
    // const spinkit = SpinKitThreeBounce(
    //   color: Colors.white, //Color(0xFF303030),
    //   size: 20.0,
    // );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return null;
          },
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                Text(
                  'Please Wait',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// for hide indicator pop up
  void hideIndicator(BuildContext context) {
    return Navigator.pop(context);
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  // final Image img;

  const CustomDialogBox({Key key, this.title, this.descriptions, this.text})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  static const double padding = 20;
  static const double avatarRadius = 45;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          Text(
            widget.descriptions,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 22),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
