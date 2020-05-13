import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:github_flutter_users/models/users.dart';

class ApiProvider{
  
  String baseUrl = 'https://api.github.com/users?language=flutter';
  
  Future<Users> getUsers() async{
    try{
    final response = await http.get(baseUrl,
    headers: {'Authorization': "token 56b2df099841da2b125a867612694dfc0c0004b4"});
    print(response.headers.toString());
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      final user = Users.fromJson(result);

      return user;
    }
    else{
      throw Exception('failed to get data');
    }
    } catch(e){
      print(e.toString());
      throw Exception(e);
    }
  }
    

    

  Future<User> getUser(url) async{
    try{
      final response = await http.get(url,
       headers:{'Authorization': 'token 56b2df099841da2b125a867612694dfc0c0004b4'});
      if(response.statusCode == 200){
        var res = json.decode(response.body);
         User user = User.fromJson(res);
         return user;
      }
      else{
        throw Exception('Failed to get data');
      }
    }catch(e){
      print(e.toString());
      throw Exception('failed to fetch data');
    }
  }
}


class UserBloc{

  StreamController _controller;
  ApiProvider _provider;
  List<User> users;
  User user;

  StreamSink<List<User>>  get sink => _controller.sink;
  Stream<List<User>> get stream => _controller.stream;

  fetchUser()async{
    //sink.add(users);
    final result = await _provider.getUsers();
    for(var item in result.items){
      var url = item.url;
      user  = await _provider.getUser(url); 
      users.add(user);
      sink.add(users);
      }

  }
  UserBloc(){
    _controller = StreamController<List<User>>();
    _provider = ApiProvider();
     users = List<User>();
    fetchUser();
  }

  dispose(){
    _controller?.close();
  }

}