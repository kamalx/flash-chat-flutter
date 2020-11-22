import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireAuth;

final _firestore = FirebaseFirestore.instance;
FireAuth.User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgTextController = TextEditingController();
  final _auth = FireAuth.FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser; // this is now a getter
      if (user != null) {
        loggedInUser = user;
        print('Logged in user: ${loggedInUser.email}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                try {
                  _auth.signOut();
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(WelcomeScreen.id),
                  );
                } catch (e) {
                  print('something went wrong, we could not log user out: $e');
                }
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgTextController.clear();
                      // [messageText] + [loggedInUser.email]
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshotContainer) {
        if (!snapshotContainer.hasData) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
          );
        }
        final messages = snapshotContainer.data.docs.reversed;
        // snapshopContainer.data is a QuerySnapshot
        // final howManyMessages = messages.length;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final msgText = message.data()['text'] ?? '[empty message]';
          final msgSender = message.data()['sender'];
          final currentUser = loggedInUser.email;

          final msgBubble = MessageBubble(
            text: msgText,
            sender: msgSender,
            isMe: currentUser == msgSender,
          );
          messageBubbles.add(msgBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.all(10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    @required this.text,
    @required this.sender,
    this.isMe,
  });

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    var shape1 = BorderRadius.only(
      bottomLeft: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );
    var shape2 = BorderRadius.only(
      topLeft: Radius.circular(30.0),
      bottomLeft: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0),
    );
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe ? shape2 : shape1,
            elevation: 1.0,
            color: isMe ? Colors.green : Colors.black12,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          isMe
              ? SizedBox(height: 0)
              : Text(
                  sender,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'monospace',
                  ),
                ),
        ],
      ),
    );
  }
}
