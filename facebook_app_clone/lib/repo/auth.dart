import 'package:facebook_app_clone/models/users.dart';
import 'package:facebook_app_clone/repo/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
//instance of firebase auth service
FirebaseAuth _auth = FirebaseAuth.instance;

User _fromfirebaseUser(user){
  return user != null? User(
    uid: user.uid,
    name: user.displayName == null ? 'Anonymous' : user.displayName,
    avatarUrl: user.photoUrl) : null;

}

Stream<User> get user{
  return _auth.onAuthStateChanged.map(_fromfirebaseUser);
}

Future updateProfile({String name, String photoUrl}) async{
  var user = await _auth.currentUser();
 UserUpdateInfo info = UserUpdateInfo();
 if(name != null) info.displayName = name;
 if(photoUrl != null) info.photoUrl = photoUrl;
  user.updateProfile(info);
}


// sign out

Future signOut() async{
  try{
     await _auth.signOut();
  }catch(e){
    throw Exception('unable to sign out');
  }
}



// register with email and password
Future<User> register(email, password) async{
  try{
    final AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    updateProfile(name:'Anonymous');
    DatabaseService(uid: user.uid).creaateUserRecord('anonymous', '');
    return _fromfirebaseUser(user);

  }catch(e){
    print(e);
    throw Exception('failed to register');
  }
}

Future<User> signIn(email, password) async{
  try{
  final AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
  final user = result.user;
  return _fromfirebaseUser(user);
  }catch(e){
    print(e);
    throw Exception('Unable to sign in');
  }
}

}
