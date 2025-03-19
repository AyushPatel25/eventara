import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/org_feedback_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';

class OrgFeedbackPage extends StatelessWidget {
  final String eventId;
  final OrgFeedbackController controller = Get.put(OrgFeedbackController());

  OrgFeedbackPage({required this.eventId, Key? key}) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchFeedback(eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextStyleHelper.CustomText(
          text: 'Feedback',
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w600,
          fontSize: 25,
          fontFamily: Assets.fontsPoppinsBold,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.whiteColor,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 20),
                  TextStyleHelper.CustomText(
                    text: controller.errorMessage.value,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsRegular,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => controller.fetchFeedback(eventId),
                    child: TextStyleHelper.CustomText(
                      text: "Try Again",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.feedbackList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_neutral,
                  color: AppColors.whiteColor,
                  size: 60,
                ),
                SizedBox(height: 20),
                TextStyleHelper.CustomText(
                  text: "No feedback available for this event",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: Assets.fontsPoppinsRegular,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Average rating section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextStyleHelper.CustomText(
                    text: "Average Rating",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 30),
                      SizedBox(width: 5),
                      TextStyleHelper.CustomText(
                        text: controller.averageRating.toStringAsFixed(1),
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        fontFamily: Assets.fontsPoppinsBold,
                      ),
                      TextStyleHelper.CustomText(
                        text: " / 5",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: Assets.fontsPoppinsRegular,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  TextStyleHelper.CustomText(
                    text: "Based on ${controller.feedbackList.length} reviews",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    fontFamily: Assets.fontsPoppinsRegular,
                  ),
                ],
              ),
            ),

            // Feedback list
            Expanded(
              child: ListView.builder(
                itemCount: controller.feedbackList.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final feedback = controller.feedbackList[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextStyleHelper.CustomText(
                                text: feedback['username'] ?? 'Anonymous',
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                SizedBox(width: 5),
                                TextStyleHelper.CustomText(
                                  text: "${feedback['rating'] ?? 0}",
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: Assets.fontsPoppinsBold,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextStyleHelper.CustomText(
                          text: feedback['comment'] ?? 'No comment',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}