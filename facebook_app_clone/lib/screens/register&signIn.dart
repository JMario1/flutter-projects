
import 'package:facebook_app_clone/repo/auth.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in/Register')
      ),
          body: Container(
            padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                  'Facebook',
                  style: TextStyle(
                      fontFamily: 'avenir',
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Connect with friends and stay safe',
                  style: TextStyle(
                      fontFamily: 'avenir',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              TextFormField(
                validator: (value)=> value.isEmpty? 'Please Enter email': null,
                onChanged: (value)=> email = value,
                ),
              SizedBox(height: 10), 
              TextFormField(
                 validator: (value)=> value.isEmpty? 'Please Enter password': null,
                onChanged: (value)=> password = value,
              ),
              SizedBox(height: 10), 
              Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)
                    ),
                    child: Text('sign in'),
                    onPressed: ()async{
                      await AuthService().signIn(email, password);
                    })),
                  SizedBox(width: 10), 
                  Expanded(child: RaisedButton(
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)
                    ),
                    child: Text('Register'),
                    onPressed: ()async{
                      await AuthService().register(email, password);
                    }))
                ],
              ),
              SizedBox(height: 10),
              Text(
                'By signing up, you have accepted Terms and Conditions of this service',
                style: TextStyle(
                  fontFamily: 'avenir',
                  ),
              )
            ]
          )),
      ),
    );
  }
}

const formDecoration = 
          InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 5.0)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.pink, width:5.0)
            ), 
          );