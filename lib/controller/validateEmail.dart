import 'package:email_validator/email_validator.dart';
import 'package:eventapp/componets/snack_bar.dart';
import 'package:eventapp/controller/auth_controller.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/otppage.dart';

void validateEmail({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required BuildContext context,
  required String userType,
}) {
  final String email = emailController.text.trim();
  final String password = passwordController.text.trim();
  final bool isValid = EmailValidator.validate(email);

  if (!isValid) {
    Get.closeAllSnackbars();
    mySnackBar('Please enter a valid email');
  } else if (password.isEmpty) {
    Get.closeAllSnackbars();
    mySnackBar('Please enter your password');
  } else {
    FocusScope.of(context).unfocus();
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    //authController.login(email: email, password: password);
    //authController.singUp(email: email, password: password);
  }

  print("User Type: $userType");
}
