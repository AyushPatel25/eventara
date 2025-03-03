import 'package:avatar_plus/avatar_plus.dart';
import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_field.dart';
import 'package:eventapp/controller/profile_cont.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextStyleHelper.CustomText(
              text: "Edit Profile",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
              fontFamily: Assets.fontsPoppinsBold
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
                child: Obx(() {
                  usernameController.text = profileController.username.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Obx((){
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=${Uri.encodeComponent(profileController.username.value)}&background=B0B0B0&color=00000"),
                            );
                          })
                        ),
                      ),
                      const SizedBox(height: 30,),

                      TextStyleHelper.CustomText(
                          text: "Name",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsRegular
                      ),
                      const SizedBox(height: 10,),


                      CustomTextField(icon: Iconsax.profile_circle_copy,
                          hintText: "Enter name",
                        controller: usernameController,
                      ),

                      const SizedBox(height: 20,),

                      TextStyleHelper.CustomText(
                          text: "Phone number",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsRegular
                      ),
                      const SizedBox(height: 10,),
                      CustomTextField(icon: Iconsax.call_copy,
                          hintText: "Enter phone number"),

                      const SizedBox(height: 20,),

                      TextStyleHelper.CustomText(
                          text: "Email",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsRegular
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 55,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(10),
                          border:
                          Border.all(color: AppColors.lightGrey, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.mail_outline_rounded, color: AppColors
                                .lightGrey),
                            SizedBox(width: 15),
                            TextStyleHelper.CustomText(
                                text: profileController.email.value,
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60,),
                    ],
                  );
                }),
                ),
            ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
                label: "Update profile",
                onPressed: () async {
                  profileController.updateUserName(profileController.uid.value, usernameController.text);
                  profileController.updateOrgName(profileController.uid.value, usernameController.text);
                  Fluttertoast.showToast(
                    msg: "Profile updated successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    //timeInSecForIosWeb: 3,
                  );
                  profileController.fetchUserData();
                  profileController.fetchOrganizerData();
                }
            ),
          ),
          ),
    );
  }
}
