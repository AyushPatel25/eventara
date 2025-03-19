import 'package:eventapp/componets/org_upcoming_card.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/profile_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../componets/org_past_card.dart';
import 'controller/org_home_cont.dart';

class OrganizerHome extends StatelessWidget {
  OrganizerHome({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final OrganizerEventsController eventsController = Get.put(OrganizerEventsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          // Standard AppBar
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.profile_circle,
                  color: AppColors.whiteColor,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextStyleHelper.CustomText(
                      text: "Hi, ${GetStorage().read('organizerName')}👋",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ],
                ),
              ],
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
                          "https://ui-avatars.com/api/?name=${Uri.encodeComponent(profileController.username.value)}&background=B0B0B0&color=00000"),
                    );
                  }),
                ),
              ),
              SizedBox(width: 20),
            ],
            // Add the TabBar in the AppBar's bottom
            bottom: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.whiteColor,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: Assets.fontsPoppinsBold,
              ),
              unselectedLabelColor: AppColors.lightGrey,
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: Assets.fontsPoppinsBold,
              ),
              tabs: const [
                Tab(text: "Upcoming events"),
                Tab(text: "Past events"),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await eventsController.fetchOrganizerEvents();
            },
            color: AppColors.primaryColor,
            child: TabBarView(
              children: [
                Obx(() {
                  if (eventsController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (eventsController.upcomingEvents.isEmpty) {
                    return Center(
                      child: TextStyleHelper.CustomText(
                        text: "No Upcoming Events",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: Assets.fontsPoppinsRegular,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: eventsController.upcomingEvents.length,
                    itemBuilder: (context, index) {
                      return OrgUpcomingCard(
                        index: index,
                        eventData: eventsController.upcomingEvents[index],
                      );
                    },
                  );
                }),

                // Past Events Tab
                Obx(() {
                  if (eventsController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (eventsController.pastEvents.isEmpty) {
                    return Center(
                      child: TextStyleHelper.CustomText(
                        text: "No Past Events",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: Assets.fontsPoppinsRegular,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: eventsController.pastEvents.length,
                    itemBuilder: (context, index) {
                      return OrgPastCard(
                        index: index,
                        eventData: eventsController.pastEvents[index],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}