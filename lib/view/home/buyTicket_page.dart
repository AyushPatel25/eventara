import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/buyTicket_cont.dart';
import 'package:eventapp/view/home/eticket.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../componets/ticketCard.dart';
import '../../generated/assets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuyticketPage extends StatelessWidget {
  final BuyTicketController buyTicketController = Get.put(BuyTicketController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return Opacity(
              opacity: buyTicketController.isButtonEnabled ? 1.0 : 0.5,
              child: CustomButton(
                label: "Buy Ticket",
                onPressed: buyTicketController.isButtonEnabled
                    ? () => buyTicketController.openCheckout()
                    : () {},
              ),
            );
          }),
        ),

        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextStyleHelper.CustomText(
            text: "Buy Ticket",
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 25,
            fontFamily: Assets.fontsPoppinsBold,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Obx(() {
                return buildShimmerOrText(
                  text: "Ticket Details",
                  isLoading: buyTicketController.isLoading.value,
                );
              },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (buyTicketController.isLoading.value) {
                  return ListView.builder(
                    itemCount: 3, // Show 3 shimmer placeholders
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[800]!,
                        highlightColor: Colors.grey[500]!,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                }

                if (buyTicketController.categories.isEmpty) {
                  return Center(
                    child: Text(
                      "No tickets available",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: buyTicketController.categories.length,
                  itemBuilder: (context, index) {
                    return Ticketcard(index: index, buyTicketController: buyTicketController);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerOrText({required String text, required bool isLoading}) {
    return isLoading
        ? Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[500]!,
      child: Container(
        height: 20,
        width: 150,
        color: Colors.grey[700],
      ),
    )
        : TextStyleHelper.CustomText(
      text: text,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      fontFamily: Assets.fontsPoppinsBold,
    );
  }
}
