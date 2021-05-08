import 'package:chat_app/src/Auth/user_auth.dart';
import 'package:chat_app/src/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _appName(),
              _name(),
              _email(),
              _password(),
              _loginButton(),
              _newUserSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appName() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'CHAT APP',
        style: TextStyle(
          fontSize: 30,
          color: Variables.appColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _name() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: CustomTextField(
        controller: _nameController,
        focusNode: _nameFocus,
        icon: Icon(
          Icons.person,
          size: 10,
          color: Variables.appColor,
        ),
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
        titleText: 'Name',
        hintText: 'Name',
      ),
    );
  }

  Widget _email() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomTextField(
        controller: _emailController,
        focusNode: _emailFocus,
        icon: Icon(
          Icons.email,
          size: 10,
          color: Variables.appColor,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
        titleText: 'Email',
        hintText: 'Email',
      ),
    );
  }

  Widget _password() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomTextField(
        focusNode: _passwordFocus,
        obscureText: true,
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        icon: Icon(
          Icons.lock,
          size: 10,
          color: Variables.appColor,
        ),
        titleText: 'Password',
        hintText: 'Password',
      ),
    );
  }

  Widget _googleSignIn() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: CustomButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image.asset('assets/images/google.png'),
            ),
            Text(
              'Continue with Google',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        onPressed: () async {
          await UserAuth().googleAuth(context);
        },
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: CustomButton(
        child: Text(
          'Sign up',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () async {
          if (_validateButton()) {
            await UserAuth().emailAuth(
              context,
              _emailController.text,
              _passwordController.text,
              _nameController.text,
            );
          } else {
            print("Fill data...!");
          }
        },
      ),
    );
  }

  bool _validateButton() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameController.text.isNotEmpty;
  }

  Widget _newUserSignUp() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'Already User? ',
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
          TextSpan(
            text: 'Log In',
            style: TextStyle(color: Variables.appColor, fontSize: 13),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          ),
        ]),
      ),
    );
  }
}
