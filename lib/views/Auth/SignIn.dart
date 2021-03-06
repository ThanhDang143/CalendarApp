import 'package:calendar_app/misc/misc.dart';
import 'package:calendar_app/views/Auth/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 50),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            Card(
              child: TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (!isValidEmail(value)) {
                    return 'Email wrong!!!';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Card(
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value.length < 6 || value.length > 64) {
                    return 'Password wrong!!!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      signIn(context, emailController.text,
                          passwordController.text);
                    }
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
