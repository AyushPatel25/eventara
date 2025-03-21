
import 'package:eventapp/view/user/location_acc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../componets/text_field.dart';
import '../../componets/text_style.dart';
import '../../controller/auth_controller.dart';
import '../../controller/signup_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';
import '../../utills/stringconstant.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpController signUpController = Get.put(SignUpController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextStyleHelper.CustomText(
            text: "Sign Up",
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 25,
            fontFamily: Assets.fontsPoppinsBold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: signUpController.signupFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextStyleHelper.CustomText(
                    text: "Let's create your account",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    fontFamily: 'bold',
                  ),
                  const SizedBox(height: 20.0),

                  // User type selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => ChoiceChip(
                        label: TextStyleHelper.CustomText(
                          text: "Audience",
                          color: signUpController.selectedUserType.value == "Audience"
                              ? Colors.black
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'regular',
                        ),
                        showCheckmark: false,
                        selectedColor: AppColors.primaryColor,
                        selected: signUpController.selectedUserType.value == "Audience",
                        onSelected: (selected) {
                          signUpController.setUserType("Audience");
                          HapticFeedback.mediumImpact();
                        },
                      )),

                      const SizedBox(width: 10),

                      Obx(() => ChoiceChip(
                        label: TextStyleHelper.CustomText(
                          text: "Organizer",
                          color: signUpController.selectedUserType.value == "Organizer"
                              ? Colors.black
                              : AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'regular',
                        ),
                        showCheckmark: false,
                        selectedColor: AppColors.primaryColor,
                        selected: signUpController.selectedUserType.value == "Organizer",
                        onSelected: (selected) {
                          signUpController.setUserType("Organizer");
                          HapticFeedback.mediumImpact();
                        },
                      )),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Username field
                  TextFormField(
                    controller: signUpController.usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: AppColors.lightGrey),
                      hintText: "Enter your full name",
                      hintStyle: TextStyle(color: AppColors.lightGrey),
                      filled: true,
                      fillColor: AppColors.greyColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter your username" : null,
                  ),

                  SizedBox(height: 10),

                  // Email field
                  TextFormField(
                    controller: signUpController.emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.lightGrey),
                      hintText: CustomString().Email,
                      hintStyle: TextStyle(color: AppColors.lightGrey),
                      filled: true,
                      fillColor: AppColors.greyColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                    value!.isEmpty || !value.contains('@')
                        ? "Enter a valid email"
                        : null,
                  ),

                  SizedBox(height: 10),

                  // Password field
                  Obx(() => TextFormField(
                    controller: signUpController.passwordController,
                    obscureText: authController.hidePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: AppColors.lightGrey),
                      hintText: "Enter your password",
                      hintStyle: TextStyle(color: AppColors.lightGrey),
                      suffixIcon: IconButton(
                        onPressed: () {
                          authController.hidePassword.toggle();
                        },
                        icon: Icon(
                          authController.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.greyColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) =>
                    value!.length < 6 ? "Password must be 6+ characters" : null,
                  )),

                  SizedBox(height: 40),

                  // Sign Up button
                  Obx(() => ElevatedButton(
                    onPressed: () {
                      if (signUpController.signupFormKey.currentState!.validate()) {
                        signUpController.signup();
                      }
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size.fromHeight(43),
                    ),
                    child: signUpController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'bold',
                          fontSize: 17
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}