import 'package:flutter/material.dart';
import 'package:trippas/screens/tripsview.dart';
//import 'package:trippas/utils/dbhelper.dart';
//import 'package:trippas/models/trip.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      title: 'Flutter Demo',
      
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
   
  @override
  Widget build(BuildContext context) {
    
    return TripList();
    
    
  }
}
