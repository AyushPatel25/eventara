import 'dart:ui';

import 'package:eventapp/componets/button.dart';
import 'package:eventapp/controller/MapThemeController.dart';
import 'package:eventapp/controller/event_details_cont.dart';
import 'package:eventapp/view/home/buyTicket_page.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/eticket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:screenshot/screenshot.dart';

import '../../componets/text_style.dart';
import '../../controller/eticket_cont.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class EventDetails extends StatelessWidget {
  EventDetails({super.key});

  final EventDetailsController eventDetailsController = Get.put(EventDetailsController());
  final MapThemeController mapThemeController = Get.put(MapThemeController());
  final EticketController eticketController = Get.put(EticketController());

  String content = '''Get ready to dance the night away at our Music Festival!
  
Featuring top artists like The Groove Masters, Electric Beats, and more. Enjoy a diverse mix of rock, pop, and EDM.
Don’t miss this musical journey!''';

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: eventDetailsController.scrollController,
        slivers: [
        SliverAppBar(

        pinned: true,
        surfaceTintColor: AppColors.lightGrey,
        backgroundColor: Colors.black,
        flexibleSpace: FlexibleSpaceBar(
          title: Obx(
              () => eventDetailsController.isTitleVisible.value
                  ? SizedBox(
                    width: 260,
                    child: Text(
                        'Arijit Singh Music Concert In Surat',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      ),
                  )
                        : SizedBox.shrink()
          ),
          ),

        actions: [
          IconButton(
            onPressed: () {
              eticketController.shareImage();
            },
            icon: Icon(Icons.ios_share_rounded),
          ),
          SizedBox(width: 20),
        ],
      ),

        SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Center(
                child: Text(
                  'Arijit Singh Concert In Surat',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.greyColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.lightGrey,),

                        const SizedBox(width: 15,),

                        TextStyleHelper.CustomText(
                            text: "Sat, 26 Jan | 2 PM onwards",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: Assets.fontsPoppinsRegular
                        ),
                    ],
                    ),
                    const SizedBox(height: 10,),

                    Divider(
                      color: AppColors.divider,
                      height: 10,
                    ),

                    const SizedBox(height: 10,),

                    Row(
                      children: [
                        Icon(Iconsax.location_copy, size: 20, color: AppColors.lightGrey,),

                        const SizedBox(width: 15,),

                        TextStyleHelper.CustomText(
                            text: "Vesu, Surat",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: Assets.fontsPoppinsRegular
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextStyleHelper.CustomText(
                  text: 'About the event',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: Assets.fontsPoppinsBold
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: ReadMoreText(
                    content,
                  trimLines: 3,
                  textAlign: TextAlign.start,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: " Read more ",
                  trimExpandedText: " Read less ",
                  lessStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsBold,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor
                  ),
                  moreStyle: TextStyle(
                    fontSize: 16,
                      fontFamily: Assets.fontsPoppinsBold,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: Assets.fontsPoppinsRegular,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightGrey,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Icon(Iconsax.language_square_copy, size: 20, color: AppColors.lightGrey,),
                        ),
                        const SizedBox(width: 15,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleHelper.CustomText(
                                text: 'Language',
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),

                            TextStyleHelper.CustomText(
                                text: "Hindi",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Icon(Iconsax.timer_1_copy, size: 20, color: AppColors.lightGrey,),
                        ),
                        const SizedBox(width: 15,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleHelper.CustomText(
                                text: 'Duration',
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),

                            TextStyleHelper.CustomText(
                                text: "3 Hours",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Icon(Iconsax.people_copy, size: 20, color: AppColors.lightGrey,),
                        ),
                        const SizedBox(width: 15,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleHelper.CustomText(
                                text: 'Age Limit',
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),

                            TextStyleHelper.CustomText(
                                text: "15 years & above",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Icon(Iconsax.smileys_copy, size: 20, color: AppColors.lightGrey,),
                        ),
                        const SizedBox(width: 15,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleHelper.CustomText(
                                text: 'Category',
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),

                            TextStyleHelper.CustomText(
                                text: "Music",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Icon(Iconsax.info_circle_copy, size: 20, color: AppColors.lightGrey,),
                        ),
                        const SizedBox(width: 15,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleHelper.CustomText(
                                text: 'Layout',
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),

                            TextStyleHelper.CustomText(
                                text: "Outdoor",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Container(
                          //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Icon(Iconsax.profile_2user_copy, size: 20, color: AppColors.lightGrey,),
                        ),
                        const SizedBox(width: 15,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextStyleHelper.CustomText(
                                text: 'Arrangement',
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),

                            TextStyleHelper.CustomText(
                                text: "Standing",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Assets.fontsPoppinsRegular
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: TextStyleHelper.CustomText(
                  text: 'Artist/Host',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: Assets.fontsPoppinsBold
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColors.greyColor,
                        backgroundImage: NetworkImage("https://i.pinimg.com/originals/a0/98/69/a09869edf78cbe08e19e409485f7c19e.jpg"),
                      ),

                      const SizedBox(height: 10,),

                      TextStyleHelper.CustomText(
                          text: 'Arijit Singh',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: Assets.fontsPoppinsRegular
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: TextStyleHelper.CustomText(
                  text: 'Venue',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: Assets.fontsPoppinsBold
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.greyColor,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: GoogleMap(
                        onMapCreated: mapThemeController.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _pGooglePlex,
                          zoom: 13,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId("Destinaton"),
                            icon: BitmapDescriptor.defaultMarker,
                            position: _pGooglePlex,
                          )
                        },
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await eventDetailsController.getUserLocation();
                        await eventDetailsController.openMaps();
                        print("get direction");
                        },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 153, 0, 0),
                        child: Container(
                          height: 40,
                          width: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.greyColor,
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              TextStyleHelper.CustomText(
                                  text: "Get Direction",
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  fontFamily: Assets.fontsPoppinsBold
                              ),
                              SizedBox(width: 10,),
                              Icon(Icons.directions, size: 20, color: AppColors.whiteColor,),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                /*height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.greyColor,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 2,
                          sigmaY: 2,
                        ),
                        child: Image(
                          image: AssetImage(Assets.imagesMaps),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(20),

                      child: Row(
                        children: [
                          Icon(Iconsax.location_copy, size: 20, color: AppColors.whiteColor,),

                          const SizedBox(width: 15,),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextStyleHelper.CustomText(
                                    text: 'Jio Garden',
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: Assets.fontsPoppinsBold
                                ),

                                TextStyleHelper.CustomText(
                                    text: "No 3 & 4, Jio Garden Public Gate, G Block BKC, Greenfiber complex, Vesu south-394110, Surat, Gujarat, India",
                                    color: AppColors.lightGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    fontFamily: Assets.fontsPoppinsRegular
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
                ),*/
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextStyleHelper.CustomText(
                      text: 'Starts from',
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: Assets.fontsPoppinsRegular
                  ),

                  TextStyleHelper.CustomText(
                      text: "\u{20B9}999",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsRegular
                  ),
                ],
              ),
              ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //minimumSize: Size.fromHeight(20),
                  ),
                  onPressed: (){
                    Get.to(BuyticketPage());
                  },
                  child: Text("Book Tickets",
                style: TextStyle(color: Colors.black,fontFamily: 'bold', fontSize: 17),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
