import 'package:firebase_auth/firebase_auth.dart';
import 'package:frenzy/Model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future<bool> gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount != null) {

      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = _auth.currentUser;

      return Future.value(true);
    }
  }

  UserL _fireBaseUser(User user) {
    return user != null ? UserL(user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      return _fireBaseUser(firebaseUser);
    } catch(e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      return _fireBaseUser(firebaseUser);
    } catch(e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async{
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      print(e.toString());
    }
  }

  Future signOut() async {

    User user = _auth.currentUser;

    try {
      if(user.providerData[1].providerId == "google.com") {
        return await googleSignIn.disconnect();
      } else {
        return await _auth.signOut();
      }
    } catch(e) {
      print(e.toString());
    }

  }

}