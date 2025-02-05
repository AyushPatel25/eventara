import 'package:eventapp/componets/CardWidget.dart';
import 'package:eventapp/componets/text_field.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/filter_page.dart';
import 'package:eventapp/view/home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../controller/loc_cont.dart';
import '../user/location_bottom_sheet.dart';
import 'event_details.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController homeController = Get.put(HomeController());
  LocationController locationController = Get.put(LocationController());

  List list = ["All", "Concert", "Comedy", "Sport", "Party", "Show"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            //header
            SliverAppBar(
              collapsedHeight: 60,
              backgroundColor: Colors.black,
              centerTitle: false,
              title: GestureDetector(
                child: Obx(() => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyleHelper.CustomText(
                                text: locationController
                                            .isManualSelection.value &&
                                        locationController
                                            .selectedCity.value.isNotEmpty
                                    ? locationController.selectedCity.value
                                    : (locationController.city.value.isNotEmpty
                                        ? locationController.city.value
                                        : "Select location"),
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                fontFamily: Assets.fontsPoppinsBold),
                            TextStyleHelper.CustomText(
                                text: locationController
                                            .isManualSelection.value &&
                                        locationController
                                            .selectedState.value.isNotEmpty
                                    ? locationController.selectedState.value
                                    : (locationController.state.value.isNotEmpty
                                        ? locationController.state.value
                                        : "for better usage"),
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsBold),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )),
                onTap: () {
                  showLocationBottomSheet(context);
                },
              ),

              expandedHeight: 70,

              //stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                title: TextStyleHelper.CustomText(
                    text: '',
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    fontFamily: Assets.fontsPoppinsBold),
              ),
              actions: [
                GestureDetector(
                  onTap: (){
                    Get.to(ProfilePage());
                  },
                    child: Icon(
                      Iconsax.profile_circle_copy,
                      color: AppColors.whiteColor,
                      size: 25,
                )),
                SizedBox(width: 20),
              ],
            ),

            //search bar
            SliverAppBar(
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              elevation: 0,
              pinned: true,
              /*bottom: const PreferredSize(
                preferredSize: Size.fromHeight(-3.0),
                child: SizedBox(),
              ),*/
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.whiteColor, width: 2),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(FilterPage());
                        },
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppColors.whiteColor),
                            SizedBox(width: 10),
                            TextStyleHelper.CustomText(
                                text: "Search events",
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            //categories
            StatefulBuilder(
              builder: (context, setState) {
                return SliverAppBar(
                  surfaceTintColor: Colors.black,
                  backgroundColor: Colors.black,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: SizedBox(
                        height: 80,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  homeController.updateCategory(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: homeController.indexCategory.value ==
                                          index
                                      //? AppColors.primaryColor.withOpacity(0.2)
                                      ? AppColors.whiteColor
                                      : AppColors.greyColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: homeController.indexCategory.value ==
                                            index
                                        //? AppColors.primaryColor
                                        ? AppColors.whiteColor
                                        : Colors.white,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: TextStyleHelper.CustomText(
                                        text: list[index],
                                        color: homeController
                                                    .indexCategory.value ==
                                                index
                                            //? AppColors.primaryColor
                                            ? Colors.black
                                            : AppColors.whiteColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        fontFamily: homeController
                                                    .indexCategory.value ==
                                                index
                                            ? Assets.fontsPoppinsBold
                                            : Assets.fontsPoppinsRegular,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextStyleHelper.CustomText(
                    text: 'Top picks',
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    fontFamily: Assets.fontsPoppinsBold),
              ),
            ),

            //Carousel slider
            StatefulBuilder(
              builder: (context, setState) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              enlargeCenterPage: true,
                              enlargeFactor: 0.5,
                              onPageChanged: (index, _) =>
                                  homeController.updatePageIndecator(index)),
                          items: [
                            ImageSlider(),
                            ImageSlider(),
                            ImageSlider(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Obx(
                            () => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Container(
                                    width: 20,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: homeController
                                                  .curousalCurrentIndex.value ==
                                              i
                                          ? AppColors.whiteColor
                                          : AppColors.divider,
                                    ),
                                    margin: EdgeInsets.only(right: 10),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextStyleHelper.CustomText(
                    text: 'All events',
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    fontFamily: Assets.fontsPoppinsBold),
              ),
            ),

            SliverToBoxAdapter(
              child: GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 320,
                ),
                itemBuilder: (context, index) => Cardwidget(
                  index: index,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ImageSlider() {
    return GestureDetector(
      onTap: () {
        Get.to(EventDetails());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.greyColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image(
            image: AssetImage(Assets.imagesPoster),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
