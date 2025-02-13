import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/buyTicket_cont.dart';
import 'package:eventapp/view/home/eticket.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/ticketCard.dart';
import '../../generated/assets.dart';

class BuyticketPage extends StatelessWidget {
  final BuyTicketController buyTicketController = Get.put(BuyTicketController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomButton(
            label: "Purchase",
            onPressed: () async {
              for (int i = 0; i < buyTicketController.categories.length; i++) {
                if (buyTicketController.categories[i].selectedTickets.value > 0) {
                  await buyTicketController.purchase(i);
                }
              }
              Get.to(Eticket());
            },
          ),
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
              child: TextStyleHelper.CustomText(
                text: "Ticket Details",
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                fontFamily: Assets.fontsPoppinsBold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (buyTicketController.categories.isEmpty) {
                  return Center(
                    child: Text("No tickets available", style: TextStyle(color: Colors.white, fontSize: 18)),
                  );
                } else {
                  return ListView.builder(
                    itemCount: buyTicketController.categories.length,
                    itemBuilder: (context, index) {
                      return Ticketcard(index: index, buyTicketController: buyTicketController);
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}