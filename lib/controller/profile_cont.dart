import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/profile_page.dart';
import 'package:eventapp/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GetStorage box = GetStorage();

  RxString username = "Loading...".obs;
  RxString email = "Loading...".obs;
  RxString uid = ''.obs;

  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        uid.value = userDoc['uid'];
        username.value = userDoc['username'];
        email.value = userDoc['email'];


        box.write('username', username.value);
        box.write('email', email.value);
      }
    } else {
      Get.snackbar("Error", "User not found", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Future<void> fetchOrganizerData() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot userDoc = await _firestore.collection('organizers').doc(user.uid).get();
  //     if (userDoc.exists) {
  //       uid.value = userDoc['oid'];
  //       username.value = userDoc['username'];
  //       email.value = userDoc['email'];
  //
  //
  //       box.write('username', username.value);
  //       box.write('email', email.value);
  //     }
  //   } else {
  //     Get.snackbar("Error", "User not found", snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  Future<void> updateUserName(String uid, String newName) async{
    if(newName.isNotEmpty){
      await _firestore.collection('users').doc(uid).update({'username': newName});
      name.value = newName;
      Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green);
    }
  }
  Future<void> logout() async {
    await _auth.signOut();
    box.erase();
    Get.offAll(LoginPage());
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //     (route) => false,
    // );
  }

  void showLogoutConfirmation() {
    Get.dialog(
        Dialog(
          backgroundColor: AppColors.greyColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                TextStyleHelper.CustomText(
                    text: "Log Out",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontFamily: Assets.fontsPoppinsBold),
                SizedBox(
                  height: 5,
                ),
                TextStyleHelper.CustomText(
                    text: "Are you sure you want to log out?",
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsBold),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: AppColors.divider,
                  thickness: 1,
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(Get.overlayContext!);
                      },
                      child: TextStyleHelper.CustomText(
                          text: 'Cancel',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsRegular),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: AppColors.divider,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    TextButton(
                      onPressed: logout,
                      child: TextStyleHelper.CustomText(
                          text: 'Log Out',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsRegular),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );


  }
}
