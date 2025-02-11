// import 'package:eventapp/componets/text_style.dart';
// import 'package:eventapp/controller/auth_controller.dart';
// import 'package:eventapp/controller/signup_cont.dart';
// import 'package:eventapp/utills/appcolors.dart';
// import 'package:eventapp/view/user/location_acc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../componets/button.dart';
// import '../../generated/assets.dart';
// import '../../utills/stringconstant.dart';
//
// class SignUp extends StatelessWidget {
//   SignUp({super.key});
//
//   //final FirebaseAuthService authService = FirebaseAuthService();
//   // final _formKey = GlobalKey<FormState>();
//   // final TextEditingController _usernameController = TextEditingController();
//   // final TextEditingController _emailController = TextEditingController();
//   // final TextEditingController _passwordController = TextEditingController();
//   final RxBool isLoading = false.obs;
//   final SignUpController signUpController = Get.put(SignUpController());
//   final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   final String _selectedUserType = "Audience";
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: TextStyleHelper.CustomText(
//             text: "Sign Up",
//             color: AppColors.whiteColor,
//             fontWeight: FontWeight.w600,
//             fontSize: 25,
//             fontFamily: Assets.fontsPoppinsBold,
//           ),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20),
//           child: Center(
//             child: Form(
//               key: signUpController.signupFormKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 16),
//                   TextStyleHelper.CustomText(
//                     text: "Let's create your account",
//                     color: AppColors.whiteColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 25,
//                     fontFamily: Assets.fontsPoppinsBold,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: signUpController.usernameController,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(
//                           Icons.person, color: AppColors.whiteColor),
//                       hintText: "Enter your full name",
//                       hintStyle: TextStyle(color: AppColors.lightGrey),
//                       filled: true,
//                       fillColor: AppColors.greyColor,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: AppColors.whiteColor),),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: AppColors.whiteColor),),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: (value) =>
//                     value!.isEmpty ? "Please enter your full name" : null,
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextFormField(
//                     controller: signUpController.emailController,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(
//                           Icons.email_outlined, color: Colors.white),
//                       hintText: CustomString().Email,
//                       hintStyle: TextStyle(color: AppColors.lightGrey),
//                       filled: true,
//                       fillColor: AppColors.greyColor,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: AppColors.whiteColor),),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: AppColors.whiteColor),),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: (value) =>
//                     value!.isEmpty || !value.contains('@')
//                         ? "Enter a valid email"
//                         : null,
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextFormField(
//                     controller: signUpController.passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.lock, color: Colors.white),
//                       hintText: "Enter your Password",
//                       hintStyle: TextStyle(color: AppColors.lightGrey),
//                       filled: true,
//                       fillColor: AppColors.greyColor,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: AppColors.whiteColor),),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(color: AppColors.whiteColor),),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     validator: (value) =>
//                     value!.length < 6 ? "Password must be 6+ characters" : null,
//                   ),
//                   const SizedBox(height: 50.0),
//                   Obx(
//                         () =>
//                     isLoading.value
//                         ? Center(child: CircularProgressIndicator())
//                         : CustomButton(
//                       label: 'Create Account',
//                       onPressed: () {
//                         if (signUpController.signupFormKey.currentState!
//                             .validate()) {
//                           signUpController.signup();
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

import 'package:eventapp/view/user/location_acc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../componets/text_field.dart';
import '../../componets/text_style.dart';
import '../../controller/auth_controller.dart';
import '../../controller/signup_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';
import '../../utills/stringconstant.dart';


class SignUpPage extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());
  final TextEditingController _passwordController = TextEditingController();

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
                  const SizedBox(height: 16),
                TextFormField(
                  controller: signUpController.usernameController,
                  decoration: InputDecoration(
                        prefixIcon: Icon(
                            Icons.person, color: AppColors.whiteColor),
                        hintText: "Enter your full name",
                        hintStyle: TextStyle(color: AppColors.lightGrey),
                        filled: true,
                        fillColor: AppColors.greyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                  validator: (value) => value!.isEmpty ? "Enter your username" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: signUpController.emailController,
                  decoration: InputDecoration(
                        prefixIcon: Icon(
                            Icons.email_outlined, color: Colors.white),
                        hintText: CustomString().Email,
                        hintStyle: TextStyle(color: AppColors.lightGrey),
                        filled: true,
                        fillColor: AppColors.greyColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),),
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
                TextFormField(
                  controller: signUpController.passwordController,
                  obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
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
                          borderSide: BorderSide(color: AppColors.whiteColor),),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.whiteColor),),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) =>
                      value!.length < 6 ? "Password must be 6+ characters" : null,
                    ),


                SizedBox(height: 40),
                Obx(() => ElevatedButton(
                  onPressed: () {
                        if (signUpController.signupFormKey.currentState!
                            .validate()) {
                          signUpController.signup();
                        }
                        Get.offAll(Location());
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20)
                    minimumSize: Size.fromHeight(53),
                  ),
                  child: signUpController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Sign Up", style: TextStyle(color: Colors.black,fontFamily: 'bold', fontSize: 17),),
                )),
                // const SizedBox(height: 40,),
                //Image.asset(Assets.imagesSignUp,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

