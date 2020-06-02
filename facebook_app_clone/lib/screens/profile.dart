import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:facebook_app_clone/repo/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:facebook_app_clone/repo/database.dart';
//import 'package:facebook_app_clone/models/users.dart';

class ProfileUpdate extends StatefulWidget {
  final String name;
  final String photoUrl;
  ProfileUpdate({this.name, this.photoUrl});
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  File _image;
  String fileName;
  TextEditingController contr = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      fileName = '${DateTime.now()}.jpeg';
    });
  }

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
    await AuthService().updateProfile(photoUrl: url);

    Navigator.of(context).pop();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: ListView(children: [
          Center(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  backgroundImage: _image != null
                      ? FileImage(_image)
                      : widget.photoUrl.runtimeType == String
                          ? NetworkImage(widget.photoUrl)
                          : null,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => getImage(),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                RaisedButton(
                  onPressed: () => imageUpload(),
                  child: Text('upload image'),
                )
              ],
            ),
          ),
          SizedBox(height: 70),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: formDecoration.copyWith(hintText: 'Enter name'),
                initialValue: widget.name,
                validator: (value) => value.isNotEmpty ? null : 'Enter name',
                onChanged: (value) {
                  setState(() => name = value);
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
              child: Text('update'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await AuthService().updateProfile(name: name);
                  Navigator.of(context).pop(true);
                }else{
                  print('error');
                }
              }),
        ]),
      ),
    );
  }
}

var formDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 3.0),
      borderRadius: BorderRadius.circular(30.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3.0),
      borderRadius: BorderRadius.circular(30.0)),
);
