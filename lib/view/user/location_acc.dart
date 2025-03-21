import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../componets/text_style.dart';
import '../../controller/loc_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';
import '../../utills/font_constant.dart';
import '../../componets/loc_image.dart';
import '../home/dashboard_page.dart';
import 'location_bottom_sheet.dart';

class Location extends StatelessWidget {
  Location({super.key});

  final LocationController controller = Get.put(LocationController());
  // Add a reactive loading state
  final RxBool isLoading = false.obs;

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
                          onPressed: () {
                            Get.offAll(() => DashboardPage());
                            HapticFeedback.mediumImpact();
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              backgroundColor: Colors.transparent,
                              fontFamily: Assets.fontsPoppinsBold,
                              fontSize: FontSizes.button,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 490),
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
                    Obx(() => ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                        isLoading.value = true;
                        final locationController = Get.find<LocationController>();

                        try {
                          await locationController.getLocation();

                          if (locationController.latitude.value != 'Getting Latitude..') {
                            Get.offAll(() => DashboardPage());
                          } else {
                            Get.snackbar(
                              "Location Error",
                              "Please allow location access.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Failed to fetch location: $e",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } finally {
                          isLoading.value = false; // Stop loading
                        }

                        HapticFeedback.mediumImpact();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size.fromHeight(43),
                      ),
                      child: isLoading.value
                          ? CircularProgressIndicator(color: AppColors.whiteColor)
                          : Text(
                        "Use current location",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'bold',
                          fontSize: 17,
                        ),
                      ),
                    )),
                    const SizedBox(height: 16.0),
                    Center(
                      child: InkWell(
                        onTap: () {
                          showLocationBottomSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
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