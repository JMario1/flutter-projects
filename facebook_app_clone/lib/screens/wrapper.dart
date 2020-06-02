import 'package:facebook_app_clone/models/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facebook_app_clone/screens/homepage.dart';
import 'package:facebook_app_clone/screens/register&signIn.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (user != null) {
      return HomePage();
    } else { return SignIn();
    }
    
  }
}