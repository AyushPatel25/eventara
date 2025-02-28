import 'package:eventapp/componets/CardWidget.dart';
import 'package:eventapp/componets/text_field.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/event_details_cont.dart';
import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/controller/profile_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/filter_page.dart';
import 'package:eventapp/view/home/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../componets/ImageSlider.dart';
import '../../controller/loc_cont.dart';
import '../user/location_bottom_sheet.dart';

class OrganizerHome extends StatelessWidget {
  OrganizerHome({super.key});

  HomeController homeController = Get.put(HomeController());
  // LocationController locationController = Get.put(LocationController());
  // EventDetailsController eventDetailsController = Get.put(EventDetailsController());
  ProfileController profileController = Get.put(ProfileController());

  // List list = ["All", "Concert", "Comedy", "Sport", "Party", "Show"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body:  CustomScrollView(
            slivers: [
              //header
              SliverAppBar(
                collapsedHeight: 60,
                backgroundColor: Colors.black,
                centerTitle: false,
                // title: TextStyleHelper.CustomText(
                //   text: "Hi, ${GetStorage().read('username')}",
                //   color: AppColors.whiteColor,
                //   fontWeight: FontWeight.w600,
                //   fontSize: 20,
                //     fontFamily: Assets.fontsPoppinsBold),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Iconsax.profile_circle, color: AppColors.whiteColor,),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextStyleHelper.CustomText(
                          text: "Hi, ${GetStorage().read('organizerName')}",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                            fontFamily: Assets.fontsPoppinsBold),
                      ],
                    ),
                  ],
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
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Obx((){
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=${Uri.encodeComponent(profileController.username.value)}&background=B0B0B0&color=00000"),
                          );
                        })
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),

              // //search bar
              // SliverAppBar(
              //   surfaceTintColor: Colors.black,
              //   backgroundColor: Colors.black,
              //   elevation: 0,
              //   pinned: true,
              //   /*bottom: const PreferredSize(
              //     preferredSize: Size.fromHeight(-3.0),
              //     child: SizedBox(),
              //   ),*/
              //   // flexibleSpace: FlexibleSpaceBar(
              //   //   background: Padding(
              //   //       padding: const EdgeInsets.fromLTRB(20, 7, 20, 4),
              //   //       child: Container(
              //   //         padding: EdgeInsets.symmetric(horizontal: 15),
              //   //         height: 50,
              //   //         decoration: BoxDecoration(
              //   //           color: Colors.black,
              //   //           borderRadius: BorderRadius.circular(10),
              //   //           border:
              //   //           Border.all(color: AppColors.lightGrey, width: 1),
              //   //         ),
              //   //         child: GestureDetector(
              //   //           onTap: () {
              //   //             Get.to(FilterPage());
              //   //           },
              //   //           child: Row(
              //   //             children: [
              //   //               Icon(Icons.search, color: AppColors.lightGrey),
              //   //               SizedBox(width: 10),
              //   //               TextStyleHelper.CustomText(
              //   //                   text: "Search events",
              //   //                   color: AppColors.lightGrey,
              //   //                   fontWeight: FontWeight.w400,
              //   //                   fontSize: 14,
              //   //                   fontFamily: Assets.fontsPoppinsRegular),
              //   //             ],
              //   //           ),
              //   //         ),
              //   //       )),
              //   // ),
              // ),

              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              //     child: TextStyleHelper.CustomText(
              //         text: 'Top picks',
              //         color: AppColors.whiteColor,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 20,
              //         fontFamily: Assets.fontsPoppinsBold),
              //   ),
              // ),



              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Obx(() => TextStyleHelper.CustomText(
                      text: homeController.selectedCategory.value + " Events",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold),
                  ),
                ),
              ),


              // Obx(() {
              //   child: SliverToBoxAdapter(
              //     child: GridView.builder(
              //       itemCount: 4,
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 1,
              //         mainAxisSpacing: 16,
              //         mainAxisExtent: 320,
              //       ),
              //       itemBuilder: (context, index) => Cardwidget(
              //         index: index,
              //       ),
              //     ),
              //   )
              // }
              // ),
              Obx(() {
                if (homeController.filteredEvents.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(80.0),
                        child: Column(
                          children: [
                            Image.asset(
                              Assets.imagesNoEvent,
                              height: 200,
                              width: 200,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextStyleHelper.CustomText(
                              text: "No events found!",
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: Assets.fontsPoppinsBold,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greyColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: AppColors.whiteColor, width: 2)
                                ),

                              ),
                              onPressed: () {

                                homeController.selectedFilters.keys.forEach((filterName) {
                                  homeController.updateFilter(filterName, false);
                                });

                                homeController.indexCategory.value = 0;
                                homeController.selectedCategory.value == "All";
                                homeController.updateCategory(0);

                              },
                              child: TextStyleHelper.CustomText(
                                text: "Clear filters",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: GridView.builder(
                    itemCount: homeController.filteredEvents.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 320,
                    ),
                    itemBuilder: (context, index) {
                      var event = homeController.filteredEvents[index];
                      return Cardwidget(index: index);
                    },
                  ),
                );
              })


            ],
          )

      ),
    );
  }

//   Widget ImageSlider() {
//     return GestureDetector(
//       onTap: () {
//         Get.to(EventDetails());
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           color: AppColors.greyColor,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25),
//           child: Image(
//             image: AssetImage(Assets.imagesPoster),
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }
}
