import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/favourite_cont.dart';
import '../controller/home_cont.dart';
import '../model/event_model.dart';
import '../view/home/event_details.dart';
import '../componets/text_style.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class Cardwidget extends StatelessWidget {
  final int index;
  final EventModel? eventModel;

  Cardwidget({required this.index, this.eventModel});

  final HomeController homeController = Get.find<HomeController>();
  final FavouriteController favouriteController = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    // Determine the event outside of Obx since it doesn't depend on an observable
    EventModel? event;

    if (eventModel != null) {
      // Use directly provided event model (e.g., from FavouritePage)
      event = eventModel;
    } else {
      // Use filtered events list when no specific event is provided
      if (homeController.filteredEvents.isEmpty || index >= homeController.filteredEvents.length) {
        print("ERROR: No filtered event found at index $index");
        return Center(
          child: Text(
            "Event not found",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      event = homeController.filteredEvents[index];
    }

    if (event == null) {
      return Center(
        child: Text(
          "Event data error",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    print("----------");
    print(event.title);
    print(event.category);

    return GestureDetector(
      onTap: () {
        print("Opening Event Details for eventId: ${event!.eventId}");
        Get.to(() => EventDetails(), arguments: {'eventId': event.eventId});
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, index == 0 ? 0 : 20, 20, 20), // Reduce top padding for the first card
        child: Stack(
          children: [
            Container(
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
                        placeholder: AssetImage("assets/images/placeholder.png"),
                        image: NetworkImage(event.eventImage),
                        fit: BoxFit.cover,
                        height: 200, // Added height to match Positioned top: 182
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
                                        fontFamily: Assets.fontsPoppinsRegular,
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
            // Favorite Button (wrapped in Obx)
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
                  bool isFav = favouriteController.favoriteEvents.contains(event!.eventId.toString());
                  return IconButton(
                    onPressed: () {
                      favouriteController.toggleFavourite(event!.eventId.toString());
                    },
                    icon: Icon(
                      isFav ? Iconsax.heart : Iconsax.heart_copy,
                      color: isFav ? Colors.red.withOpacity(0.8) : Colors.white,
                    ),
                  );
                }),
              ),
            ),
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
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: TextStyleHelper.CustomText(
                          text: event.getMonth(),
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}