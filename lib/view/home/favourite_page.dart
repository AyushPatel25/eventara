import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../componets/CardWidget.dart';
import '../../componets/text_style.dart';
import '../../controller/favourite_cont.dart';
import '../../controller/home_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';


class FavouritePage extends GetView<FavouriteController> {
  FavouritePage({super.key});
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              title: TextStyleHelper.CustomText(
                text: 'Favourites',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                fontFamily: Assets.fontsPoppinsBold,
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {


                // if (controller.favoriteEvents.isEmpty) {
                //   return Padding(
                //     padding: const EdgeInsets.only(top: 50),
                //     child: Center(
                //       child: TextStyleHelper.CustomText(
                //         text: "No liked events yet!",
                //         color: AppColors.whiteColor,
                //         fontWeight: FontWeight.w500,
                //         fontSize: 18,
                //         fontFamily: Assets.fontsPoppinsBold,
                //       ),
                //     ),
                //   );
                // }

                // Filter events based on favorite event IDs
                final favoriteEvents = homeController.events
                    .where((event) => controller.favoriteEvents.contains(event.eventId.toString()))
                    .toList();

                if (favoriteEvents.isEmpty) {
                  print("No matching events found for favoriteEvents: ${controller.favoriteEvents}");
                  print("Available events: ${homeController.events.map((e) => e.eventId)}");
                  return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: TextStyleHelper.CustomText(
                        text: "No liked events yet!",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        fontFamily: Assets.fontsPoppinsBold,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.only(top: 10, bottom: 20), // Control spacing
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: favoriteEvents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 320,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return Cardwidget(
                      index: index,
                      eventModel: favoriteEvents[index], // Pass the EventModel directly
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}