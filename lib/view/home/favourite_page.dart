import 'package:eventapp/componets/CardWidget.dart';
import 'package:eventapp/controller/favourite_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../componets/text_style.dart';
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
            fontSize: 30,
            fontFamily: Assets.fontsPoppinsBold,
          ),
        ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.favoriteEvents.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: TextStyleHelper.CustomText(
                        text: "No liked events yet!",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: Assets.fontsPoppinsBold,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.favoriteEvents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 320,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    String eventId = controller.favoriteEvents.elementAt(index);
                    int eventIndex = homeController.events.indexWhere(
                            (event) => event.eventId.toString() == eventId
                    );

                    if (eventIndex == -1) return SizedBox();

                    return Cardwidget(index: eventIndex);
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
