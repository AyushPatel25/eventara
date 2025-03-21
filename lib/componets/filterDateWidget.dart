import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/myevent_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/event_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../generated/assets.dart';

class FilterDateWidget extends StatelessWidget {
  final int index;

  const FilterDateWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    return Obx(() {
      if (eventController.selectedEvents.isEmpty ||
          index >= eventController.selectedEvents.length) {
        print("ERROR: No event found at index $index in selectedEvents");
        return const Center(
          child: Text(
            "Event not found",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final event = eventController.selectedEvents[index];

      // Get artist name from the artists list in EventModel
      String artistName = 'Unknown Artist';
      if (event.artists.isNotEmpty) {
        artistName = event.artists.first.artistName;
      }

      return GestureDetector(
        onTap: () {
          print("Opening Event Details for eventId: ${event.eventId}");
          Get.to(() => EventDetails(), arguments: {'eventId': event.eventId});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Opacity(
                    opacity: 0.8,
                    child: FadeInImage(
                      placeholder: AssetImage("assets/images/placeholder.png"),
                      image: NetworkImage(event.eventImage),
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
              ),
              const SizedBox(width: 10),
              Expanded(
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
                    const SizedBox(height: 3),
                    TextStyleHelper.CustomText(
                      text: artistName,
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: Assets.fontsPoppinsRegular,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        TextStyleHelper.CustomText(
                          text: "${event.eventDate} | ",
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                        Expanded(
                          child: TextStyleHelper.CustomText(
                            text: event.location,
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: Assets.fontsPoppinsRegular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      );
    });
  }
}