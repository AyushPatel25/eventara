import 'package:eventapp/componets/otp_pinput.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../generated/assets.dart';

class Cardwidget extends StatelessWidget {
  final int index;
  Cardwidget({required this.index});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(EventDetails());
      },
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              Container(

                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    ),
                    child: Image.asset(Assets.imagesPoster, height: 200, fit: BoxFit.fitWidth,)
                  ),

                  /*Divider(
                    color: Colors.white,
                    height: 10,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextStyleHelper.CustomText(
                                    text: "Arijit Singh Concert",
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  fontFamily: Assets.fontsPoppinsBold
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                      color: AppColors.lightGrey,
                                      size: 15,
                                    ),
                                    SizedBox(width: 2,),
                                    TextStyleHelper.CustomText(
                                        text: "Surat, Gujarat",
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.access_time_rounded,
                                      color: AppColors.lightGrey,
                                      size: 15,
                                    ),
                                    SizedBox(width: 2,),
                                    TextStyleHelper.CustomText(
                                        text: "05:00 PM",
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                  ],
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                  )
                ],
                ),
              ),

              //favourite
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, -1),
                          blurRadius: 8,
                        )
                      ]
                  ),
                  child: Obx(() => IconButton(
                      onPressed: (){
                        homeController.toggleFavourite(index);
                      },
                      icon: Icon(
                        homeController.favoriteEvents.contains(index)
                            ? Iconsax.heart
                            :Iconsax.heart_copy,
                        color: homeController.favoriteEvents.contains(index)
                            ?Colors.red
                            :AppColors.whiteColor,
                      ),
                  )),
                ),
              ),
              Positioned(
                top: 170,
                  right: 10,
                  child: Container(
                    height: 85,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, -1),
                          blurRadius: 8,
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextStyleHelper.CustomText(
                            text: "Sat",
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: Assets.fontsPoppinsBold
                        ),
                        Divider(
                          color: AppColors.lightGrey,
                          height: 10,
                        ),
                        TextStyleHelper.CustomText(
                            text: "26",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: Assets.fontsPoppinsBold
                        ),
                        TextStyleHelper.CustomText(
                            text: "Jan",
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: Assets.fontsPoppinsRegular
                        ),
                      ],
                    ),
                  ),
              ),

        ],
          ),
      ),
    );
    /*return Padding(
        padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(Assets.imagesPoster),
                ),
                Expanded(
                  child: Container(),
                ),
                Divider(
                  color: Colors.black,
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                  child: TextStyleHelper.CustomText(
                      text: "Arijit Singh Concert",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      fontFamily: Assets.fontsPoppinsBold
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                      color: AppColors.whiteColor,
                        size: 25,
                      ),
                      SizedBox(width: 2,),
                      TextStyleHelper.CustomText(
                          text: "Surat, Gujarat",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: Assets.fontsPoppinsRegular
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.access_time_rounded,
                        color: AppColors.whiteColor,
                        size: 25,
                      ),
                      SizedBox(width: 2,),
                      TextStyleHelper.CustomText(
                          text: "05:00 PM",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: Assets.fontsPoppinsRegular
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );*/
  }
}
