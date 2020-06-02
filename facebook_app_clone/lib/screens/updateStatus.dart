import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app_clone/models/users.dart';
import 'package:facebook_app_clone/repo/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MakePost extends StatefulWidget {
  @override
  _MakePostState createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
  File _image;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String fileName;
  Post post;
  String postText;
  bool isValid = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      fileName = '${DateTime.now()}.jpeg';
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<String> imageUpload() async {
      var task = DatabaseService().uploadImage(_image, fileName);
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(children: [
              StreamBuilder(
                  stream: task.events,
                  builder: (context, snapshot) {
                    Widget subtitle;
                    if (snapshot.hasData) {
                      final StorageTaskSnapshot snap = snapshot.data.snapshot;
                      subtitle = Text(
                          '${((snap.bytesTransferred / snap.totalByteCount) * snap.totalByteCount / 1024).toStringAsFixed(2)} Kb sent');
                    } else {
                      subtitle = Text('Starting');
                    }
                    return ListTile(
                        title: task.isSuccessful && task.isComplete
                            ? Text('Done')
                            : Text('Uploading image'),
                        subtitle: subtitle);
                  }),
            ]);
          });
      String url = await (await task.onComplete).ref.getDownloadURL();

      Navigator.of(context).pop();
      return url;
    }

    User user = Provider.of<User>(context);
    print(user);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (isValid) {
                  String imageUrl = _image == null ? null : await imageUpload();
                  post = Post(
                      text: postText,
                      time: DateTime.now(),
                      user: user,
                      comments: [],
                      likes: 0,
                      imageUrl: imageUrl);
                  await DatabaseService().makePost(post, Timestamp.now());
                  Navigator.of(context).pop(true);
                } else {
                  print('invalid post');
                }
              })
        ],
      ),
      body: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl) ?? null,
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(width: 10.0),
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLines: 100,
                              decoration: formDecoration.copyWith(
                                  hintText: 'write something'),
                              validator: (value) =>
                                  value.isEmpty ? 'Post cannot be empty' : null,
                              onChanged: (value) => postText = value),
                        ),
                      ),
                      onChanged: () {
                        if (_formKey.currentState.validate()) {
                          setState(() => isValid = true);
                        } else {
                          isValid = false;
                        }
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => getImage(),
                ),
                Container(
                  //height: MediaQuery.of(context).size.height,
                  //width: MediaQuery.of(context).size.width,
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(
                          _image,
                          fit: BoxFit.contain,
                        ),
                )
              ],
            ),
          ]),
    );
  }
}

var formDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 5.0),
      borderRadius: BorderRadius.circular(30.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3.0),
      borderRadius: BorderRadius.circular(30.0)),
);
