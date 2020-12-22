import 'package:calendar_app/misc/misc.dart';
import 'package:calendar_app/services/Auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: appBar('Sign In'),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
            ),
            Card(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Card(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Anonymous'),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnonymous();
                    if (result == null) {
                      print('SignIn fail');
                    } else {
                      print('SignIn Success');
                      print(result);
                    }
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  child: Text('Sign In'),
                  onPressed: () {},
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  child: Text('Sign Up'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
