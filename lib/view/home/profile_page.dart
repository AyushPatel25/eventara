import 'package:eventapp/componets/button.dart';
import 'package:eventapp/controller/profile_cont.dart';
import 'package:eventapp/controller/signup_cont.dart';
import 'package:eventapp/view/home/edit_profile.dart';
import 'package:eventapp/view/user/signUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final SignUpController signUpController = Get.put(SignUpController());



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextStyleHelper.CustomText(
                text: "Profile",
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                fontFamily: Assets.fontsPoppinsBold
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Icon(Iconsax.profile_circle, size: 100,),
                  ),
                  const SizedBox(height: 10,),

                  Obx((){
                    return TextStyleHelper.CustomText(
                        text: profileController.username.value,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        fontFamily: Assets.fontsPoppinsBold
                    );
                  }),
                  TextStyleHelper.CustomText(
                      text: profileController.email.value,
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold
                  ),
                  const SizedBox(height: 10,),

                  SizedBox(
                    width: 200,
                    height: 45,
                    child: CustomButton(
                        label: "Edit Profile",
                        onPressed: (){
                          Get.to(EditProfile());
                        },
                    ),
                  ),

                  const SizedBox(height: 40,),

                  Divider(color: AppColors.divider,),
                  GestureDetector(
                    child: ListTile(
                      leading: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greyColor,
                        ),

                        child: Icon(Iconsax.bill_copy, size: 25, color: AppColors.lightGrey,),
                      ),
                      title: TextStyleHelper.CustomText(
                          text: "Terms of Service",
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          fontFamily: Assets.fontsPoppinsBold
                      ),
                      trailing: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),
                        child: Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.lightGrey,),
                    ),
                    ),
                  ),

                  Divider(color: AppColors.divider,),
                  GestureDetector(
                    child: ListTile(
                      leading: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greyColor,
                        ),

                        child: Icon(Iconsax.lock_copy, size: 25, color: AppColors.lightGrey,),
                      ),
                      title: TextStyleHelper.CustomText(
                          text: "Privacy policy",
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          fontFamily: Assets.fontsPoppinsBold
                      ),
                      trailing: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greyColor,
                        ),
                        child: Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.lightGrey,),
                      ),
                    ),
                  ),

                  Divider(color: AppColors.divider,),
                  GestureDetector(
                    onTap: profileController.showLogoutConfirmation,
                    child: ListTile(
                      leading: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greyColor,
                        ),

                        child: Icon(Iconsax.logout_1_copy, size: 20, color: AppColors.lightGrey,),
                      ),
                      title: TextStyleHelper.CustomText(
                          text: "Logout",
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          fontFamily: Assets.fontsPoppinsBold
                      ),
                      trailing: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greyColor,
                        ),
                        child: Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.lightGrey,),
                      ),
                    ),
                  ),
                  Divider(color: AppColors.divider,),
                ],
              ),
            ),
          ),
        )
    );
  }
}
