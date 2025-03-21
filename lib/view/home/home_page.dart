import 'package:eventapp/view/home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../componets/CardWidget.dart';
import '../../componets/ImageSlider.dart';
import '../../componets/text_style.dart';
import '../../controller/event_details_cont.dart';
import '../../controller/home_cont.dart';
import '../../controller/loc_cont.dart';
import '../../controller/profile_cont.dart';
import '../../generated/assets.dart';
import '../../model/event_model.dart';
import '../../utills/appcolors.dart';
import '../user/location_bottom_sheet.dart';
import 'event_details.dart';
import 'filter_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController homeController = Get.put(HomeController());
  LocationController locationController = Get.put(LocationController());
  EventDetailsController eventDetailsController =
  Get.put(EventDetailsController());
  ProfileController profileController = Get.put(ProfileController());

  List list = ["All", "Concert", "Comedy", "Sport", "Party", "Show"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            // Header
            SliverAppBar(
              collapsedHeight: 60,
              backgroundColor: Colors.black,
              centerTitle: false,
              title: GestureDetector(
                child: Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.whiteColor,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyleHelper.CustomText(
                          text: locationController
                              .isManualSelection.value &&
                              locationController
                                  .selectedCity.value.isNotEmpty
                              ? locationController.selectedCity.value
                              : (locationController.cityLive.value.isNotEmpty
                              ? locationController.cityLive.value
                              : (locationController
                              .cityLive.value.isNotEmpty
                              ? locationController.cityLive.value
                              : "Select location")),
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                        TextStyleHelper.CustomText(
                          text: locationController
                              .isManualSelection.value &&
                              locationController
                                  .selectedState.value.isNotEmpty
                              ? locationController.selectedState.value
                              : (locationController.state.value.isNotEmpty
                              ? locationController.state.value
                              : (locationController
                              .stateLive.value.isNotEmpty
                              ? locationController.stateLive.value
                              : "Select location")),
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: AppColors.whiteColor),
                  ],
                )),
                onTap: () {
                  showLocationBottomSheet(context);
                },
              ),
              expandedHeight: 70,
              flexibleSpace: FlexibleSpaceBar(
                title: TextStyleHelper.CustomText(
                  text: '',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.to(ProfilePage());
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Obx(() {
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          "https://ui-avatars.com/api/?name=${Uri.encodeComponent(profileController.username.value)}&background=B0B0B0&color=00000",
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),

            // Search bar
            SliverAppBar(
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              elevation: 0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 7, 20, 4),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(FilterPage());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.lightGrey, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppColors.lightGrey),
                          SizedBox(width: 10),
                          TextStyleHelper.CustomText(
                            text: "Search events",
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: Assets.fontsPoppinsRegular,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Categories
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
                                  color: homeController.indexCategory.value == index
                                      ? AppColors.whiteColor
                                      : AppColors.greyColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: homeController.indexCategory.value == index
                                        ? AppColors.whiteColor
                                        : AppColors.greyColor,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: TextStyleHelper.CustomText(
                                        text: list[index],
                                        color: homeController.indexCategory.value == index
                                            ? Colors.black
                                            : AppColors.lightGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: homeController.indexCategory.value == index
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

            // Single Obx for all sections
            Obx(() {
              if (homeController.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor),
                    ),
                  ),
                );
              }

              // All sections will render only when isLoading is false
              return SliverList(
                delegate: SliverChildListDelegate([
                  // Top picks
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextStyleHelper.CustomText(
                      text: 'Top picks',
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 4),
                            enlargeCenterPage: true,
                            enlargeFactor: 0.5,
                            onPageChanged: (index, _) =>
                                homeController.updatePageIndecator(index),
                          ),
                          items: List.generate(
                            homeController.carouselEvents.length,
                                (index) => ImageSlider(index: index),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0; i < 3; i++)
                                Container(
                                  width: 20,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: homeController.curousalCurrentIndex.value == i
                                        ? AppColors.whiteColor
                                        : AppColors.divider,
                                  ),
                                  margin: EdgeInsets.only(right: 10),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category-based Events
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: TextStyleHelper.CustomText(
                      text: homeController.selectedCategory.value + " Events",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                  if (homeController.filteredEvents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.imagesNoEvent,
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(height: 10),
                          TextStyleHelper.CustomText(
                            text: "No events found!",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      itemCount: homeController.filteredEvents.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 320,
                      ),
                      itemBuilder: (context, index) {
                        return Cardwidget(index: index);
                      },
                    ),

                  // Near Events
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: TextStyleHelper.CustomText(
                      text: "Near Events",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                  if (!locationController.isLocationEnabled.value)
                    Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Column(
                        children: [
                          Icon(Icons.location_off,
                              size: 80, color: AppColors.whiteColor),
                          const SizedBox(height: 10),
                          TextStyleHelper.CustomText(
                            text: "Your live location is off!",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              locationController.getLocation();
                            },
                            child: Text("Turn On Location"),
                          ),
                        ],
                      ),
                    )
                  else
                        () {
                      List<EventModel> nearEvents = [];
                      if (locationController.isManualSelection.value) {
                        nearEvents = homeController.events.where((event) {
                          bool cityMatch = event.eventCity?.toLowerCase() ==
                              locationController.selectedCity.value.toLowerCase();
                          bool stateMatch = event.eventState?.toLowerCase() ==
                              locationController.selectedState.value.toLowerCase();
                          return cityMatch && stateMatch;
                        }).toList();
                      } else {
                        nearEvents = homeController.nearEvents;
                      }

                      if (nearEvents.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Column(
                            children: [
                              Image.asset(
                                Assets.imagesNoEvent,
                                height: 200,
                                width: 200,
                              ),
                              const SizedBox(height: 10),
                              TextStyleHelper.CustomText(
                                text: "No events found near you!",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: nearEvents.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 320,
                        ),
                        itemBuilder: (context, index) {
                          return Cardwidget(
                            index: index,
                            eventModel: nearEvents[index],
                          );
                        },
                      );
                    }()
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}