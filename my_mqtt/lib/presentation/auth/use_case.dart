import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/application/service_locator.dart';

class AuthUseCases {
  final FirebaseAuth _auth = sl<FirebaseAuth>();
  final FirebaseFunctions _functions = sl<FirebaseFunctions>();

  Future<void> createAccount(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> logIn(String email, String password) async {
    var userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (!userCredential.user!.emailVerified) throw EmailVerifyingException;
  }

  Future<HttpsCallableResult> changeRole(String password) => _functions.httpsCallable('changeRole').call(password);

  Future<void> logOut() => _auth.signOut();

  Future<void> sendVerifyingEmail() => _auth.currentUser!.sendEmailVerification();
}