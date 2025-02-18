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
      bool isSelected = buyTicketController.selectedCategoryIndex.value == index;
      bool isOtherCategorySelected = buyTicketController.selectedCategoryIndex.value != null &&
          buyTicketController.selectedCategoryIndex.value != index;
      bool isMaxTicketsReached = buyTicketController.totalSelectedTickets.value >= 10;

      return Opacity(
        opacity: isOtherCategorySelected ? 0.5 : 1.0, // Fade effect for unselected categories
        child: Card(
          color: AppColors.greyColor,
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 120,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(120),
                      bottomRight: Radius.circular(120),
                    ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyleHelper.CustomText(
                        text: "Available: ${category.availableSpots.value} spots",
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: Assets.fontsPoppinsBold,
                      ),
                      SizedBox(height: 5),
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
                          // Decrement Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor.withOpacity(
                                  category.selectedTickets.value > 0 ? 0.5 : 0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: AppColors.primaryColor.withOpacity(
                                      category.selectedTickets.value > 0 ? 1 : 0.5), width: 2)
                              ),
                            ),
                            onPressed: category.selectedTickets.value > 0
                                ? () => buyTicketController.decrement(index)
                                : null,
                            child: Text("-", style: TextStyle(color: AppColors.whiteColor, fontSize: 20, fontFamily: Assets.fontsPoppinsRegular)),
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
                          // Increment Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor.withOpacity(
                                  (isOtherCategorySelected || isMaxTicketsReached || category.selectedTickets.value >= category.availableSpots.value)
                                      ? 0.5
                                      : 0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: AppColors.primaryColor.withOpacity(
                                      category.selectedTickets.value > 0 ? 1 : 0.5), width: 2)
                              ),
                            ),
                            onPressed: (isOtherCategorySelected || isMaxTicketsReached || category.selectedTickets.value >= category.availableSpots.value)
                                ? null
                                : () => buyTicketController.increment(index),
                            child: Text("+", style: TextStyle(color: AppColors.whiteColor, fontSize: 20, fontFamily: Assets.fontsPoppinsRegular)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
