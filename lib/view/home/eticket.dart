import 'package:eventapp/componets/button.dart';
import 'package:eventapp/controller/eticket_cont.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class Eticket extends StatelessWidget {
  Eticket({super.key});

  EticketController eticketController = Get.put(EticketController());

  @override
  Widget build(BuildContext context) {

    var eventData = Get.arguments;

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: (){
                  Get.offAll(DashboardPage());
                },
                icon: Icon(Icons.arrow_back)
            ),
            title: TextStyleHelper.CustomText(
                text: "E-Ticket",
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                fontFamily: Assets.fontsPoppinsBold
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: GestureDetector(
                  onTap: (){
                    eticketController.saveAndShare();
                  },
                    child: Icon(
                      Icons.ios_share_rounded,
                      size: 25,
                      color: AppColors.whiteColor,
                    )
                ),
              ),
            ],
          ),
          body: Padding(
              padding: EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Screenshot(
                        controller: eticketController.screenshotController,
                        child: Center(
                          child: Container(
                            height: 710,
                            width: 350,
                            child: Center(
                              child: Stack(
                                children: [
                                  Image.asset(Assets.imagesTicket, height: 710,fit: BoxFit.fill, width: 350,),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(35, 65, 35, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Container(
                                          width: double.infinity,
                                        alignment: Alignment.topCenter,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: AppColors.greyColor,

                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image(
                                            image: AssetImage(Assets.imagesPoster),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        ),
                                        SizedBox(height: 20,),
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.topCenter,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.transparent,

                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: FittedBox(
                                                      child: Text(
                                                        eventData['eventName'] ?? 'Event Name',
                                                        style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20,
                                                          fontFamily: Assets.fontsPoppinsBold,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              SizedBox(height: 10,),

                                              Divider(
                                                color: AppColors.divider,
                                                thickness: 2,
                                              ),

                                              SizedBox(height: 10,),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Container(
                                                    height: 40,
                                                    width: 130,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextStyleHelper.CustomText(
                                                            text: 'Location',
                                                            color: AppColors.lightGrey,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),

                                                        TextStyleHelper.CustomText(
                                                            text: "Vesu, Surat",
                                                            color: AppColors.whiteColor,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 15,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 10,),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Container(
                                                    height: 40,
                                                    width: 130,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextStyleHelper.CustomText(
                                                            text: 'Date',
                                                            color: AppColors.lightGrey,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),

                                                        TextStyleHelper.CustomText(
                                                            text: "26/01/2025",
                                                            color: AppColors.whiteColor,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 15,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),
                                                      ],
                                                    ),
                                                  ),



                                                  Container(
                                                    height: 40,
                                                    width: 130,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextStyleHelper.CustomText(
                                                            text: 'Time',
                                                            color: AppColors.lightGrey,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),

                                                        TextStyleHelper.CustomText(
                                                            text: "10:00 PM",
                                                            color: AppColors.whiteColor,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 15,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: 15,),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Container(
                                                    height: 40,
                                                    width: 130,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextStyleHelper.CustomText(
                                                            text: 'Seat No.',
                                                            color: AppColors.lightGrey,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),

                                                        TextStyleHelper.CustomText(
                                                            text: "No Seat",
                                                            color: AppColors.whiteColor,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 15,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),
                                                      ],
                                                    ),
                                                  ),



                                                  Container(
                                                    height: 40,
                                                    width: 130,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextStyleHelper.CustomText(
                                                            text: 'Gate No.',
                                                            color: AppColors.lightGrey,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            fontFamily: Assets.fontsPoppinsRegular
                                                        ),

                                                        TextStyleHelper.CustomText(
                                                            text: "1-A",
                                                            color: AppColors.whiteColor,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 15,
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
                                    ],
                                    ),
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(125, 545, 125, 0),
                                    child: Column(
                                      children: [
                                        QrImageView(
                                          data: "ayush@gmail.com",
                                          version: QrVersions.auto,
                                          size: 120,
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: AppColors.whiteColor,
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            //minimumSize: Size.fromHeight(20),
                          ),
                          onPressed: (){
                            eticketController.captureAndSave();
                          },
                          child: Text("Download",
                            style: TextStyle(color: Colors.black,fontFamily: 'bold', fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        )
    );
  }
}
