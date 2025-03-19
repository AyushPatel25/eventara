import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/feedback_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import '../../componets/button.dart';
import '../../generated/assets.dart';

class FeedbackPage extends StatelessWidget {
  final String eventId;
  final String eventName;
  final String eventImage;

  FeedbackPage({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventImage,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the controller here with the eventId
    final FeedBackController feedBackController = Get.put(
      FeedBackController(eventId: eventId),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextStyleHelper.CustomText(
            text: "Feedback",
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 25,
            fontFamily: Assets.fontsPoppinsBold,
          ),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
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
                      child: eventImage.isNotEmpty
                          ? Image.network(
                        eventImage,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/poster.png',
                          fit: BoxFit.contain,
                        ),
                      )
                          : Image.asset('assets/images/poster.png', fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextStyleHelper.CustomText(
                    text: eventName,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextStyleHelper.CustomText(
                      text: "What is your rating?",
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                        () => RatingBar.builder(
                      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                      direction: Axis.horizontal,
                      minRating: 1,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                      onRatingUpdate: (value) {
                        feedBackController.rating.value = value;
                      },
                      initialRating: feedBackController.rating.value,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextStyleHelper.CustomText(
                    text: "Please share your opinion",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  TextStyleHelper.CustomText(
                    text: "about the event",
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: feedBackController.textEditingController,
                    cursorColor: AppColors.whiteColor,
                    maxLines: 4,
                    minLines: 3,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                      hintText: "Write your feedback",
                      hintStyle: TextStyle(
                        color: AppColors.lightGrey,
                        fontFamily: 'regular',
                      ),
                      filled: true,
                      fillColor: AppColors.greyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.lightGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: "Send feedback",
                    onPressed: () => feedBackController.submitFeedback(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}