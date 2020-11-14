import 'package:firebase_auth/firebase_auth.dart' as FireAuth;
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FireAuth.FirebaseAuth.instance;
  String email, password;
  bool _showspinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(color: Colors.black),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                title: 'Log In',
                onPressed: () async {
                  setState(() {
                    _showspinner = true;
                  });
                  try {
                    var session = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (session != null) {
                      print(session);
                      // navigate to the chat screen
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      _showspinner = false;
                    });
                  } on FireAuth.FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      print('\n\nbad password!\n\n');
                    }
                    print('Error occurred during signin: $e');
                  } catch (e) {
                    print('Exception: code: ${e.code}, message: ${e.message}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
