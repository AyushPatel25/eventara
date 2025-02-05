import 'package:eventapp/componets/snack_bar.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  FirebaseAuth auth = FirebaseAuth.instance;

  /*void login({String? email, String? password}){

    isLoading(true);

    auth.signInWithEmailAndPassword(email: email!, password: password!)
    .then((value){
      isLoading(false);
      Get.offAll(() => Location());
    }).catchError((e){
      isLoading(false);
      mySnackBar("$e");
    });
  }

  void singUp({String? email, String? password}){

    isLoading(true);

    auth.createUserWithEmailAndPassword(email: email!, password: password!)
    .then((value){
      isLoading(false);
      Get.offAll(() => Location());
    }).catchError((e){
      isLoading(false);
      print("Error in authentication $e");
    });
  }*/

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      print("User Created: ${credential.user?.uid}");
      return credential.user;
    } catch (e){
      print("Error during sign-up: $e");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e){
      print("Some error occured");
    }
    return null;
  }
}