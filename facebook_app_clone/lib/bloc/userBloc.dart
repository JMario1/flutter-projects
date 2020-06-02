import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:facebook_app_clone/repo/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserBloc{
CollectionReference _collection = Firestore.instance.collection('facebook_users');
StreamController _controller;
DatabaseService _service;

UserBloc(){

_controller = StreamController();
_service = DatabaseService();
getData();
}

getData(){
 var user = FirebaseAuth.instance.currentUser();
 
}

}