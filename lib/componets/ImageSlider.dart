import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/controller/event_details_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../utills/appcolors.dart';
import '../view/home/event_details.dart';

Widget ImageSlider({required int index}) {
  // Get the existing instance of HomeController
  final HomeController homeController = Get.find<HomeController>();

  return Obx(() {
    if (homeController.events.isEmpty || index >= homeController.events.length) {
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
        Get.to(() => EventDetails(), arguments: {'eventId': event.eventId});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.greyColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: FadeInImage(
            placeholder: AssetImage("assets/images/placeholder.png"),
            image: NetworkImage(event.eventImage),
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Center(
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
    );
  });
}
