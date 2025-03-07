import 'package:eventapp/componets/otp_pinput.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/event_details_cont.dart';
import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/favourite_cont.dart';
import '../generated/assets.dart';

class OrgPastCard extends StatelessWidget {
  final int index;

  const OrgPastCard({required this.index, super.key}); // Fixed constructor

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
              child: Opacity(
                opacity: 0.8,
                child: FadeInImage(
                  placeholder: const AssetImage("assets/images/placeholder.png"),
                  image: const AssetImage(Assets.imagesPoster),
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50),
                    );
                  },
                  placeholderErrorBuilder: (context, error, stackTrace) {
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
                ),
              ),
            ),
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
                          text: "Arijit Singh",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
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
          ],
        ),
      ),
    );
  }
}