import 'package:eventapp/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetController extends GetxController{
  static ForgetController get instance => Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> forgetFormKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  Future<void> sendpasswordresetemail() async{
    String email = emailController.text.trim();


    if (email.isEmpty) {
      Get.snackbar("Error", "All fields are required", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;

    await auth.sendPasswordResetEmail(email: email).then((value){
      Get.offAll(LoginPage());
      Get.snackbar("Success", "Password reset email link is been sent", snackPosition: SnackPosition.BOTTOM);
    }).catchError((onError) =>  Get.snackbar("Error", "Error in email reset", snackPosition: SnackPosition.BOTTOM));
  }

}