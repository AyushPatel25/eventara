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

import '../generated/assets.dart';

class Searchwidget extends StatelessWidget {
  final int index;
  Searchwidget({required this.index});

  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.events.isEmpty ||
          index >= homeController.events.length) {
        print("ERROR: No event found at index $index");
        return Center(
          child: Text(
            "Event not found",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final event = homeController.events[index];
      final artist = event.artists[index];

      return GestureDetector(
        onTap: () {
          print("Opening Event Details for eventId: ${event.eventId}");
          Get.to(() => EventDetails(), arguments: {'eventId': event.eventId});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Opacity(
                        opacity: 0.8,
                        child: FadeInImage(
                          placeholder:
                          AssetImage("assets/images/placeholder.png"),
                          image: NetworkImage(event.eventImage),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Center(
                              child:
                              Icon(Icons.error, color: Colors.red, size: 50),
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
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyleHelper.CustomText(
                          text: event.title,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                        SizedBox(height: 3),
                        TextStyleHelper.CustomText(
                          text: artist.artistName,
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            TextStyleHelper.CustomText(
                              text: event.eventDate + " | ",
                              color: AppColors.lightGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: Assets.fontsPoppinsRegular,
                            ),
                            SizedBox(width: 2),
                            FittedBox(
                              child: Container(
                                height: 20,
                                width: 170,
                                child: TextStyleHelper.CustomText(
                                  text: event.location,
                                  color: AppColors.lightGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily:
                                  Assets.fontsPoppinsRegular,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
          ],
        ),
      );
    });
  }
}
