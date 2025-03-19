import 'package:eventapp/componets/button.dart';
import 'package:eventapp/controller/eticket_cont.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:lottie/lottie.dart';

import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class Eticket extends StatelessWidget {
  const Eticket({super.key});

  @override
  Widget build(BuildContext context) {
    final EticketController eticketController = Get.put(EticketController());
    final arguments = Get.arguments;

    print("Received arguments: $arguments");

    // Extract ticket details
    final String eventImage = arguments['eventImage'];
    final String eventName = arguments['eventName'];
    final String eventLocation = arguments['eventLocation'];
    final String eventDate = arguments['eventDate'];
    final String ticketCategory = arguments['ticketCategory'];
    final String eventTime = arguments['eventTime'];
    final int ticketPrice = arguments['ticketPrice'];
    final int ticketCount = arguments['ticketCount'];
    final String arrangement = arguments['arrangement'];
    final List<String> ticketNumbers = arguments['ticketNumbers'];

    // Extract the navigation flag (default to false if not provided)
    final bool fromBookTicket = arguments['fromBookTicket'] ?? false;

    String qrData =
        "Event: $eventName\nLocation: $eventLocation\nCategory: $ticketCategory\nPrice: \u{20B9}${ticketPrice.toString()}\nCount: $ticketCount\nArrangement: $arrangement\nTicket No. $ticketNumbers \nEmail: ${GetStorage().read('email')}\nUsername: ${GetStorage().read('username')}";
    print(
        "Event: $eventName\nLocation: $eventLocation\nCategory: $ticketCategory\nPrice: \u{20B9}${ticketPrice.toString()}\nCount: $ticketCount\nEmail: ${GetStorage().read('email')}\nUsername: ${GetStorage().read('username')}");

    // Define the e-ticket content widget
    Widget eTicketContent = Column(
      children: [
        AppBar(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.offAll(DashboardPage());
            },
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          ),
          title: TextStyleHelper.CustomText(
            text: "E-Ticket",
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 25,
            fontFamily: Assets.fontsPoppinsBold,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GestureDetector(
                onTap: () {
                  eticketController.saveAndShare();
                },
                child: const Icon(
                  Icons.ios_share_rounded,
                  size: 25,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  Screenshot(
                    controller: eticketController.screenshotController,
                    child: Center(
                      child: Container(
                        height: 710,
                        width: 350,
                        child: Stack(
                          children: [
                            Image.asset(
                              Assets.imagesTicket,
                              height: 710,
                              fit: BoxFit.fill,
                              width: 350,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(35, 65, 35, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.greyColor,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        eventImage,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.transparent,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: FittedBox(
                                                child: Text(
                                                  eventName,
                                                  style: const TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    fontFamily: Assets.fontsPoppinsBold,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Divider(
                                          color: AppColors.divider,
                                          thickness: 2,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 280,
                                              child: FittedBox(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    TextStyleHelper.CustomText(
                                                      text: 'Location',
                                                      color: AppColors.lightGrey,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12,
                                                      fontFamily:
                                                      Assets.fontsPoppinsRegular,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    TextStyleHelper.CustomText(
                                                      text: eventLocation,
                                                      color: AppColors.whiteColor,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15,
                                                      fontFamily:
                                                      Assets.fontsPoppinsRegular,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 130,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  TextStyleHelper.CustomText(
                                                    text: 'Date',
                                                    color: AppColors.lightGrey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                  TextStyleHelper.CustomText(
                                                    text: eventDate,
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              width: 130,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  TextStyleHelper.CustomText(
                                                    text: 'Time',
                                                    color: AppColors.lightGrey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                  TextStyleHelper.CustomText(
                                                    text: eventTime,
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 130,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  TextStyleHelper.CustomText(
                                                    text: 'Category',
                                                    color: AppColors.lightGrey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                  TextStyleHelper.CustomText(
                                                    text: ticketCategory,
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              width: 130,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  TextStyleHelper.CustomText(
                                                    text: 'Ticket Price',
                                                    color: AppColors.lightGrey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                  TextStyleHelper.CustomText(
                                                    text:
                                                    "\u{20B9}${ticketPrice.toString()}",
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 40,
                                          width: 280,
                                          child: FittedBox(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                TextStyleHelper.CustomText(
                                                  text: 'Seat No.',
                                                  color: AppColors.lightGrey,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  fontFamily:
                                                  Assets.fontsPoppinsRegular,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                if (arrangement != 'Standing')
                                                  TextStyleHelper.CustomText(
                                                    text: ticketNumbers.join(', '),
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                else
                                                  TextStyleHelper.CustomText(
                                                    text: 'Standing',
                                                    color: AppColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    fontFamily:
                                                    Assets.fontsPoppinsRegular,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 45),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          child: QrImageView(
                                            data: qrData,
                                            version: QrVersions.auto,
                                            size: 120,
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: AppColors.whiteColor,
                                          ),
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        eticketController.captureAndSave();
                      },
                      child: const Text(
                        "Download",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'bold',
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            eTicketContent,
            // Show animation only if coming from Book Ticket
            if (fromBookTicket)
              FutureBuilder(
                future: Future.delayed(const Duration(seconds: 3)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.black.withOpacity(0.8),
                      child: Center(
                        child: Lottie.asset(
                          Assets.imagesCrack,
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                          repeat: false,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}