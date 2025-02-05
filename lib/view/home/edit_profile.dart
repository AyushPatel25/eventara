import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Icon(Iconsax.profile_circle, size: 100,),
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
                    CustomTextField(icon: Iconsax.profile_circle_copy, hintText: "Enter name"),

                    const SizedBox(height: 20,),

                    TextStyleHelper.CustomText(
                        text: "Phone number",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: Assets.fontsPoppinsRegular
                    ),
                    const SizedBox(height: 10,),
                    CustomTextField(icon: Iconsax.call_copy, hintText: "Enter phone number"),

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
                          Icon(Icons.mail_outline_rounded, color: AppColors.lightGrey),
                          SizedBox(width: 15),
                          TextStyleHelper.CustomText(
                              text: "abc2gmail.com",
                              color: AppColors.lightGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              fontFamily: Assets.fontsPoppinsRegular),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60,),
                    CustomButton(label: "Update profile", onPressed: (){}),
                  ],
                ),
            ),
          ),
        ),
    );
  }
}
