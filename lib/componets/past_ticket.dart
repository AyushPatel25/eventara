import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/view/home/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class PastTicket extends StatelessWidget {
  const PastTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          child: Stack(
            children: [
              Image.asset(Assets.imagesTicketRot),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                child: Row(
                  children: [
                    Container(
                      height: 110,
                      width: 235,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              'Arijit Singh Concert In Surat',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                              maxLines: 1,
                            ),
                          ),


                          SizedBox(height: 7,),

                          Row(
                            children: [

                              Container(
                                height: 24,
                                width: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextStyleHelper.CustomText(
                                        text: 'Location',
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 7,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),

                                    TextStyleHelper.CustomText(
                                        text: "Vesu, Surat",
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                height: 24,
                                width: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextStyleHelper.CustomText(
                                        text: 'Date',
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 7,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),

                                    TextStyleHelper.CustomText(
                                        text: "26/01/2025",
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                  ],
                                ),
                              ),


                              Container(
                                height: 24,
                                width: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextStyleHelper.CustomText(
                                        text: 'Time',
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 7,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),

                                    TextStyleHelper.CustomText(
                                        text: "10:00 PM",
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                height: 24,
                                width: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextStyleHelper.CustomText(
                                        text: 'Seat No.',
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 7,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),

                                    TextStyleHelper.CustomText(
                                        text: "No Seat",
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                  ],
                                ),
                              ),


                              Container(
                                height: 24,
                                width: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextStyleHelper.CustomText(
                                        text: 'Gate No.',
                                        color: AppColors.lightGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 7,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),

                                    TextStyleHelper.CustomText(
                                        text: "1-A",
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        fontFamily: Assets.fontsPoppinsRegular
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 35,),

                    Container(
                      height: 110,
                      width: 60,
                      //color: Colors.red,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Column(
                            children: [

                              TextStyleHelper.CustomText(
                                  text: 'For Feedback',
                                  color: AppColors.lightGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  fontFamily: Assets.fontsPoppinsRegular
                              ),

                              IconButton(
                                  onPressed: (){
                                    Get.to(FeedbackPage());
                                  },
                                  color: Colors.white,
                                  iconSize: 50,
                                  icon: Icon(Icons.arrow_circle_right_rounded,)
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
        )

      ],
    );
  }
}
