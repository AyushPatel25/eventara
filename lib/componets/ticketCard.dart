import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/buyTicket_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../generated/assets.dart';

class Ticketcard extends StatelessWidget {
  final BuyTicketController buyTicketController;
  final int index;
  Ticketcard({super.key, required this.index, required this.buyTicketController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var category = buyTicketController.categories[index];
      return Card(
        color: AppColors.greyColor,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              Container(
                height: 120,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(120), bottomRight: Radius.circular(120)),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: TextStyleHelper.CustomText(
                      text: category.name,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyleHelper.CustomText(
                    text: "Available: ${category.availableSpots.value} spots",
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  SizedBox(height: 2),
                  TextStyleHelper.CustomText(
                    text: "\u{20B9}${category.price} x ${category.selectedTickets.value} = \u{20B9}${category.price * category.selectedTickets.value}",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => buyTicketController.increment(index),
                        child: Text("+", style: TextStyle(color: AppColors.whiteColor, fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextStyleHelper.CustomText(
                          text: "${category.selectedTickets.value}",
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: Assets.fontsPoppinsBold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => buyTicketController.decrement(index),
                        child: Text("-", style: TextStyle(color: AppColors.whiteColor, fontSize: 20)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

