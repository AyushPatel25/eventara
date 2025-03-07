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

class Cardwidget extends StatelessWidget {
  final int index;
  Cardwidget({required this.index});

  final HomeController homeController = Get.find<HomeController>();
  final FavouriteController favouriteController =
      Get.put(FavouriteController());

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

      return GestureDetector(
        onTap: () {
          print("Opening Event Details for eventId: ${event.eventId}");
          Get.to(() => EventDetails(), arguments: {'eventId': event.eventId});
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height * 0.3,
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
                        topRight: Radius.circular(20),
                      ),
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
                                  text: event.title,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  fontFamily: Assets.fontsPoppinsBold,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: AppColors.lightGrey,
                                      size: 14,
                                    ),
                                    SizedBox(width: 2),
                                    FittedBox(
                                      child: Container(
                                        height: 20,
                                        width: 200,
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
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.access_time_filled_rounded,
                                      color: AppColors.lightGrey,
                                      size: 14,
                                    ),
                                    SizedBox(width: 2),
                                    TextStyleHelper.CustomText(
                                      text: event.time,
                                      color: AppColors.lightGrey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      fontFamily: Assets.fontsPoppinsRegular,
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
              ),

              // Favorite Button
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
                      ),
                    ],
                  ),
                  child: Obx(() {
                    bool isFav = favouriteController.favoriteEvents.contains(event.eventId.toString());

                    return IconButton(
                      onPressed: () {
                        favouriteController.toggleFavourite(event.eventId.toString());
                      },
                      icon: Icon(
                        isFav ? Iconsax.heart : Iconsax.heart_copy,
                        color: isFav ? Colors.red.withOpacity(0.8) : Colors.white,
                      ),
                    );
                  }),
                ),
              ),

              // Positioned(
              //   top: 10,
              //   right: 10,
              //   child: Container(
              //     height: 40,
              //     width: 40,
              //     decoration: BoxDecoration(
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(8),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black,
              //           offset: Offset(0, -1),
              //           blurRadius: 8,
              //         ),
              //       ],
              //     ),
              //     child: Obx(() => IconButton(
              //       onPressed: () {
              //         homeController.toggleFavourite(index);
              //       },
              //       icon: Icon(
              //         homeController.favoriteEvents.contains(index)
              //             ? Iconsax.heart
              //             : Iconsax.heart_copy,
              //         color: homeController.favoriteEvents.contains(index)
              //             ? Colors.red
              //             : AppColors.whiteColor,
              //       ),
              //     )),
              //   ),
              // ),

              // Event Date Box
              Positioned(
                top: 182,
                right: 10,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, -1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TextStyleHelper.CustomText(
                      //   text: "Sat",
                      //   color: AppColors.lightGrey,
                      //   fontWeight: FontWeight.w600,
                      //   fontSize: 15,
                      //   fontFamily: Assets.fontsPoppinsBold,
                      // ),
                      // Divider(
                      //   color: AppColors.lightGrey,
                      //   height: 10,
                      // ),
                      TextStyleHelper.CustomText(
                        text: event.getDay(),
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: Assets.fontsPoppinsBold,
                      ),
                      Container(
                        height: 20,
                        width: 46,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8)
                          ),
                        ),
                        child:Center(
                          child: TextStyleHelper.CustomText(
                            text: event.getMonth(),
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            fontFamily: Assets.fontsPoppinsRegular,
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
