import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/organizer/org_statstics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../generated/assets.dart';
import '../view/organizer/org_feedback.dart';

class OrgPastCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> eventData;

  const OrgPastCard({
    required this.index,
    required this.eventData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SizedBox(
                height: 200,
                child: eventData['eventImage'] != null && eventData['eventImage'].toString().isNotEmpty
                    ? Image.network(
                  eventData['eventImage'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      Assets.imagesPoster,
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[500]!,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                      ),
                    );
                  },
                )
                    : Image.asset(
                  Assets.imagesPoster,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextStyleHelper.CustomText(
                          text: eventData['title'] ?? "Unnamed Event",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                      ),
                      TextStyleHelper.CustomText(
                        text: eventData['eventDate'] ?? "",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        fontFamily: Assets.fontsPoppinsRegular,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: AppColors.whiteColor, width: 2)
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => OrgStatistics(eventId: eventData['eventId']));
                          },
                          child: TextStyleHelper.CustomText(
                            text: "Statistics",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: AppColors.whiteColor, width: 2)
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => OrgFeedbackPage(eventId: eventData['eventId'].toString()));
                          },
                          child: TextStyleHelper.CustomText(
                            text: "User Feedback",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}