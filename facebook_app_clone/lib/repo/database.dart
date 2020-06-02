import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app_clone/models/users.dart';
import 'package:firebase_storage/firebase_storage.dart';



class DatabaseService {
  final uid;
  DatabaseService({this.uid});

  CollectionReference _collectionUser = Firestore.instance.collection('users');
  CollectionReference _collectionPost = Firestore.instance.collection('post');

  FirebaseStorage _storage = FirebaseStorage.instance;

  StorageUploadTask uploadImage(imageFile, String fileName){
    StorageReference imageRef = _storage.ref().child('image/$fileName');
    StorageUploadTask uploadTask = imageRef.putFile(imageFile);
    return uploadTask;
  }

  Future creaateUserRecord(String name, String avatar)async{
    return  await _collectionUser.document(uid).setData({
      'name': name,
      'avatar': avatar

    });
  }

  // Future updateName(String name)async{
  //   return await _collectionUser.document(uid).updateData({
  //     'name':name
  //   });

  // }

  // Future updateAvatar(imageFile, String fileName)async{
  //   return await _collectionUser.document(uid).updateData({
  //     'avatar': uploadImage(imageFile, fileName)
  //   });

  // }

  Future makePost(Post post, Timestamp timestamp)async{
    try{
      await _collectionPost.add({
      'post': post.toMap(),
      'timestamp': timestamp.microsecondsSinceEpoch
    });
    }catch(e){
      print(e);
    }

  }

  Future makeComment(String id,  Comments comment)async{
    print(id);
    return await _collectionPost.document(id).updateData({
      'post.comments': FieldValue.arrayUnion([comment.toMap()])
    });
  }




  Stream<List<Post>> get posts {
    try{
      return _collectionPost.orderBy('timestamp', descending:true).snapshots().map((event) => event.documents.map((e){
      Post post = Post.fromMap(e.data['post']);
      post.id = e.documentID;
      return post;
    }).toList());
    }catch(e){
      print(e);
      throw Exception('unable to get post');
    }
  }

  
}
