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

class OrganizerHome extends StatelessWidget {
  OrganizerHome({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.black,
                surfaceTintColor: Colors.black,
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
                              "https://ui-avatars.com/api/?name=${Uri.encodeComponent(profileController.username.value)}&background=B0B0B0&color=00000"),
                        );
                      }),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SliverAppBar(
                pinned: true,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black,
                flexibleSpace: TabBar(
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
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    // Upcoming Events Tab
                    ListView.builder(
                      itemCount: 1, // Replace with your actual data length
                      itemBuilder: (context, index) {
                        return OrgUpcomingCard(index: index);
                      },
                    ),
                    // Past Events Tab
                    ListView.builder(
                      itemCount: 1, // Replace with your actual data length
                      itemBuilder: (context, index) {
                        return OrgPastCard(index: index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:eventapp/componets/org_upcoming_card.dart';
// import 'package:eventapp/componets/text_style.dart';
// import 'package:eventapp/controller/profile_cont.dart';
// import 'package:eventapp/generated/assets.dart';
// import 'package:eventapp/utills/appcolors.dart';
// import 'package:eventapp/view/home/profile_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// class OrganizerHome extends StatelessWidget {
//   OrganizerHome({super.key});
//
//   ProfileController profileController = Get.put(ProfileController());
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.black,
//             body: CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   pinned: true,
//                   backgroundColor: Colors.black,
//                   surfaceTintColor: Colors.black,
//                   centerTitle: false,
//                   title: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Iconsax.profile_circle, color: AppColors.whiteColor,),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextStyleHelper.CustomText(
//                               text: "Hi, ${GetStorage().read(
//                                   'organizerName')}👋",
//                               color: AppColors.whiteColor,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 20,
//                               fontFamily: Assets.fontsPoppinsBold
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   expandedHeight: 70,
//
//                   //stretch: true,
//                   flexibleSpace: FlexibleSpaceBar(
//                     title: TextStyleHelper.CustomText(
//                         text: '',
//                         color: AppColors.whiteColor,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 25,
//                         fontFamily: Assets.fontsPoppinsBold),
//                   ),
//                   actions: [
//                     GestureDetector(
//                       onTap: () {
//                         Get.to(ProfilePage());
//                       },
//                       child: SizedBox(
//                           width: 30,
//                           height: 30,
//                           child: Obx(() {
//                             return CircleAvatar(
//                               radius: 60,
//                               backgroundImage: NetworkImage(
//                                   "https://ui-avatars.com/api/?name=${Uri
//                                       .encodeComponent(
//                                       profileController.username
//                                           .value)}&background=B0B0B0&color=00000"),
//                             );
//                           })
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 ),
//                 SliverAppBar(
//                   pinned: true,
//                   surfaceTintColor: Colors.black,
//                   backgroundColor: Colors.black,
//                   flexibleSpace: TabBar(
//                     tabAlignment: TabAlignment.start,
//                     isScrollable: true,
//                     indicatorColor: AppColors.primaryColor,
//                     labelColor: AppColors.whiteColor,
//                     labelStyle: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14,
//                       fontFamily: Assets.fontsPoppinsBold,
//                     ),
//                     unselectedLabelColor: AppColors.lightGrey,
//                     unselectedLabelStyle: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 14,
//                       fontFamily: Assets.fontsPoppinsBold,
//                     ),
//                     tabs: const [
//                       Tab(text: "Upcoming events"),
//                       Tab(text: "Past events"),
//                     ],
//                   ),
//                 ),
//
//                 // SliverFillRemaining(
//                 //   child: TabBarView(
//                 //       children: [
//                 //         OrgUpcomingCard(index: 1),
//                 //         Center(
//                 //           child: Icon(Icons.account_circle),
//                 //         ),
//                 //       ]
//                 //   ),
//                 // )
//                 SliverList(
//                   delegate: SliverChildListDelegate([
//                     TabBarView(
//                       children: [
//                         OrgUpcomingCard(index: 1),
//                         Center(
//                           child: Icon(Icons.account_circle),
//                         ),
//                       ],
//                     ),
//                   ]),
//                 ),
//
//                 /*
//                 SliverFillRemaining(
//                 child: TabBarView(
//                   children: [
//                     Obx(() {
//                       if (ticketController.isLoading.value) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: AppColors.primaryColor,
//                           ),
//                         );
//                       }
//
//                       if (ticketController.upcomingTickets.isEmpty) {
//                         return Center(
//                           child: TextStyleHelper.CustomText(
//                             text: "No Upcoming Tickets",
//                             color: AppColors.whiteColor,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             fontFamily: Assets.fontsPoppinsRegular,
//                           ),
//                         );
//                       }
//
//                       return ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         itemCount: ticketController.upcomingTickets.length,
//                         itemBuilder: (context, index) {
//                           return UpcomingTicket(
//                             ticket: ticketController.upcomingTickets[index],
//                           );
//                         },
//                       );
//                     }),
//
//                     Obx(() {
//                       if (ticketController.isLoading.value) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: AppColors.primaryColor,
//                           ),
//                         );
//                       }
//
//                       if (ticketController.pastTickets.isEmpty) {
//                         return Center(
//                           child: TextStyleHelper.CustomText(
//                             text: "No Past Tickets",
//                             color: AppColors.whiteColor,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             fontFamily: Assets.fontsPoppinsRegular,
//                           ),
//                         );
//                       }
//
//                       return ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         itemCount: ticketController.pastTickets.length,
//                         itemBuilder: (context, index) {
//                           return PastTicket(
//                             ticket: ticketController.pastTickets[index],
//                           );
//                         },
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//                 * */
//               ],
//             ),
//           )
//       ),
//     );
//   }
// }