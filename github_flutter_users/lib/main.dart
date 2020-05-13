import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github_flutter_users/api/apiProvider.dart';
import 'package:github_flutter_users/models/users.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Github Users'),
      ),
      body: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  UserBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = UserBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.only(top:20.0),
                physics: ClampingScrollPhysics(),
                itemBuilder: (contex, index) {
                  return Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].avatarUrl),
                        radius: 30.0,
                        backgroundColor: Colors.brown,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data[index].name ?? snapshot.data[index].login,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),
                          Text(snapshot.data[index].location ?? 'Location null')
                        ],
                      ),
                    ),
                    SizedBox(width:5.0),
                    FlatButton(
                        onPressed: () async{ 
                            String url = '${snapshot.data[index].htmlUrl}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 7.0),
                            //alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text('View Profile',
                                  style: TextStyle(fontSize:10),),
                                  SizedBox(width: 5.0),
                                  Image.asset('images/github.png', scale: 3)
                                ]))),
                  ]);
                },
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black38,
                    ),
                itemCount: snapshot.data.length);
          } else {
            return Center(child: SpinKitWave(color: Colors.blue, size: 60.0,));
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
}
