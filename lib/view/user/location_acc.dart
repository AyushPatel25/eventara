
import 'package:eventapp/componets/text_field.dart';
import 'package:eventapp/utills/stringconstant.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/user/location_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/button.dart';
import '../../componets/text_style.dart';
import '../../controller/loc_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';
import '../../utills/font_constant.dart';
import '../../componets/loc_image.dart';

class Location extends StatelessWidget {
  Location({super.key});

  LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: (){Get.offAll(() => DashboardPage());},
                            child: Text('Skip', style: TextStyle(
                              color: AppColors.whiteColor,
                              backgroundColor: Colors.transparent,
                              fontFamily: Assets.fontsPoppinsBold,
                              fontSize: FontSizes.button,
                              fontWeight: FontWeight.w600,
                            ),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 490,),
                    Center(
                      child: TextStyleHelper.CustomText(
                        text: "Let's find!",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: FontSizes.heading2,
                        fontFamily: 'bold',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: TextStyleHelper.CustomText(
                        text: "Discover what's happening nearby.",
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: FontSizes.caption,
                        fontFamily: 'regular',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    CustomButton(
                      label: 'Use current location',
                      onPressed: () async {
                        final locationController = Get.find<LocationController>();
                        await locationController.getLocation();

                        if (locationController.latitude.value != 'Getting Latitude..') {
                          Get.offAll(() => DashboardPage());
                        } else {
                          Get.snackbar("Location Error", "Please allow location access.");
                        }
                      },
                    ),

                    const SizedBox(height: 16.0),
                    Center(
                      child: InkWell(
                        onTap: (){
                          showLocationBottomSheet(context);
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 2, color: AppColors.primaryColor),)
                            ),
                            child: TextStyleHelper.CustomText(
                              text: "Select location manually",
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: FontSizes.button,
                              fontFamily: Assets.fontsPoppinsBold,
                              ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
