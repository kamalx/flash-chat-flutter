import 'dart:ui';

import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  // make sure we do some cleanup on dispose()
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation = ColorTween(
      begin: Colors.blueGrey[200],
      end: Colors.white,
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Flash ',
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[900]),
                    ),
                    RotateAnimatedTextKit(
                      transitionHeight: 60.0,
                      duration: Duration(milliseconds: 800),
                      pause: Duration(milliseconds: 300),
                      repeatForever: true,
                      text: ['Fun', 'Joy', 'Chat'],
                      textStyle: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            // color: Colors.lightBlueAccent,
            RoundedButton(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// () {
//             //Go to login screen.
//             Navigator.pushNamed(context, LoginScreen.id);
//           }
class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  final double vpad;
  final double radius;
  final double width;
  final double height;

  RoundedButton({
    this.color = Colors.red,
    this.title = 'My Button',
    this.onPressed,
    this.vpad = 16.0,
    this.radius = 30.0,
    this.width = 200.0,
    this.height = 42.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vpad),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(radius),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: height,
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
