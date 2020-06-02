import 'package:facebook_app_clone/models/users.dart';
import 'package:facebook_app_clone/repo/auth.dart';
import 'package:facebook_app_clone/repo/database.dart';
import 'package:flutter/material.dart';
import 'package:facebook_app_clone/screens/updateStatus.dart';
import 'package:provider/provider.dart';
import 'package:facebook_app_clone/screens/profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
     final AuthService _auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
                  'Facebook',
                  style: TextStyle(
                      fontFamily: 'avenir',
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
        actions: <Widget>[
      Container(
        child: Center(child: Text('Clone mode')),
      padding: EdgeInsets.symmetric(
         horizontal: 10.0),
         margin: EdgeInsets.symmetric(
         vertical: 10.0),
      decoration: BoxDecoration(
         color: Colors.black87,
          borderRadius: BorderRadius.circular(30.0),
          border:
    Border.all(color: Colors.grey[300], width: 3.0))),
          PopupMenuButton(
            icon: Icon(Icons.person, color: Colors.blue,),
            itemBuilder: (context){
              return [
                PopupMenuItem(
                  child:  RaisedButton.icon(onPressed: () async => await _auth.signOut(), icon: Icon(Icons.person), label: Text('sign out'))
                ),
                PopupMenuItem(child: RaisedButton(
                  child: Text('profile'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileUpdate(name: user.name, photoUrl: user.avatarUrl)) 
                )))];
            },)
        ],
      ),
      body: PostFeed(),
    );
  }
}



class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  Stream<List<Post>> _post;

  @override
  void initState() {
    super.initState();
    _post = DatabaseService().posts;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    commentPage(List<Comments> comment, String id) {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            var _comment = comment;
            return CommentForm(
                comment: _comment,
                id: id,
                valueChanged: (value) => _comment = value);
          });
    }

    

    return Container(
         padding: const EdgeInsets.all(16.0),
        child: ListView(
        children: <Widget>[
        Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 20.0),
      child: Row(
        children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl) ?? null,
    backgroundColor: Colors.blue,
        ),
        SizedBox(
    width: 10,
        ),
        Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border:
    Border.all(color: Colors.grey[300], width: 3.0)),
      child: GestureDetector(
        child: Text('Write something'),
        onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
      builder: (context) => MakePost())),
      ),
    ),
        ),
        ],
      ),
    ),
    Divider(
      height: 10.0,
      thickness: 1.0,
      color: Colors.grey[300],
    ),
        StreamBuilder<List<Post>>(
          stream: _post,
          builder: (context, snapshot) {
            print(snapshot.data.toString());
            if (snapshot.hasData) {
              try {
            return ListView.separated(
              physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
                print(snapshot.data[index].time.toString());
                Duration timeDiff =
                    DateTime.now().difference(snapshot.data[index].time);
                print(timeDiff);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
              backgroundImage: snapshot.data[index].user.avatarUrl ==
                      null
                  ? null
                  : NetworkImage(snapshot.data[index].user.avatarUrl),
              backgroundColor: Colors.blue,
                      ),
                      title: Text(snapshot.data[index].user.name,
              style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.bold,
              ),),
                      subtitle: Text(
                '${timeDiff.inDays != 0 ? timeDiff.inDays.toString() + (" day ago") : timeDiff.inHours != 0 ? timeDiff.inHours.toString() + (" hr ago") : timeDiff.inMinutes != 0 ? timeDiff.inMinutes.toString() + (" min ago") : timeDiff.inSeconds.toString() + (" sec ago")}'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('${snapshot.data[index].text}',
              style: TextStyle(
                fontFamily: 'avenir',
                fontWeight: FontWeight.w600,
              ),
              
               ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical:10.0),
                      child: snapshot.data[index].imageUrl == null
                ? null
                : FadeInImage.assetNetwork(
                  fit: BoxFit.contain,
                  placeholder: 'images/place.png',
                  image: snapshot.data[index].imageUrl),
                    ),
                    Row(
                      children: <Widget>[
              SizedBox(width: 100.0,),//like animation
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                color: Colors.grey[300], width: 3.0)),
                  child: GestureDetector(
                      onTap: () => commentPage(
                snapshot.data[index].comments,
                snapshot.data[index].id),
                      child: Text('Write comment')),
                ),
              )
                      ],
                    )
                  ]);
          },
          separatorBuilder: (context, value) => Divider(
                    height: 30.0,
                    color: Colors.white70,
                    thickness: 15.0,
                  ),
          itemCount: snapshot.data.length);
              } catch (e) {
            print(e);
            throw Exception('cound to build post');
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        ],
      ),
      );
  }
}

class CommentForm extends StatefulWidget {
  final List<Comments> comment;
  final String id;
  final Function valueChanged;
  CommentForm({this.comment, this.id, this.valueChanged});
  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String commentText;
  TextEditingController _contr = TextEditingController();
  var userid = AuthService().user;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    var data = widget.comment;
    data.sort((a, b) => a.time.compareTo(b.time));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start, 
      children: <Widget>[
        SizedBox(height: 10.0),
        Text('Comments',
        style: TextStyle(
          fontFamily: 'avenir',
          fontSize: 20.0
        ),),
        SizedBox(height: 10.0),
        if (data.isNotEmpty)
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Duration timeDiff =
                      DateTime.now().difference(data[index].time);
                  return Padding(
                    padding: const EdgeInsets.only(top:16.0),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: data[index].user.avatarUrl == null
                              ? null
                              : NetworkImage(data[index].user.avatarUrl),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            children: <Widget>[
                              Text(data[index].user.name,
                              style: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),),
                            SizedBox(width: 10.0),
                              Text(
                                  '${timeDiff.inDays != 0 ? timeDiff.inDays.toString() + (" day ago") : timeDiff.inHours != 0 ? timeDiff.inHours.toString() + (" hr ago") : timeDiff.inMinutes != 0 ? timeDiff.inMinutes.toString() + (" min ago") : timeDiff.inSeconds.toString() + (" sec ago")}')
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(data[index].text,
                            style: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.w600,
                              ),),
                          )
                        ])
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, value) => Divider(
                      height: 30.0,
                      color: Colors.white70,
                      thickness: 13.0,
                    ),
                itemCount: data.length),
          )
        else
          Expanded(child: Center(child: Text('No comments yet'))),

        Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                       padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 50,
                        style: TextStyle(
                          fontFamily: 'avenir',
                        ),
                        decoration: formDecoration.copyWith(hintText: 'Write your comment'),
                controller: _contr,
                validator: (value) =>
                        value.isEmpty ? 'comment cannot be empty' : null,
                onChanged: (value) => commentText = value,
              ),
                    ),
                  )),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Comments comment = Comments();
                      comment.text = commentText;
                      comment.time = DateTime.now();
                      comment.user = user;
                      widget.comment.add(comment);
                      await DatabaseService().makeComment(widget.id, comment);
                      setState(() {
                        data = widget.comment;
                        widget.valueChanged(data);
                        _contr.clear();
                      });
                    } else {
                      return print('invalid comment');
                    }
                  })
            ],
          ),
        ),
      ],
    ));
  }
}




var formDecoration = 
          InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3.0),
              borderRadius: BorderRadius.circular(30.0)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width:3.0),
               borderRadius: BorderRadius.circular(30.0)
            ), 
          );
