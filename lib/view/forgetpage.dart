import 'package:eventapp/controller/forgetpage_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../componets/text_style.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';
import '../utills/stringconstant.dart';

class Forgetpage extends StatelessWidget {
  Forgetpage({super.key});

  final ForgetController forgetController = Get.put(ForgetController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextStyleHelper.CustomText(
              text: "Forget Password",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
              fontFamily: Assets.fontsPoppinsBold,
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: forgetController.emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                        Icons.email_outlined, color: AppColors.lightGrey),
                    hintText: CustomString().Email,
                    hintStyle: TextStyle(color: AppColors.lightGrey),
                    filled: true,
                    fillColor: AppColors.greyColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.lightGrey),),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.lightGrey),),
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
                SizedBox(height: 40,),

                Obx(() => ElevatedButton(
                  onPressed: () {
                    forgetController.sendpasswordresetemail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20)
                    minimumSize: Size.fromHeight(43),
                  ),
                  child: forgetController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Sign Up", style: TextStyle(color: Colors.black,fontFamily: 'bold', fontSize: 17),),
                )),
              ],
            ),
          ),
        )
    );
  }
}
