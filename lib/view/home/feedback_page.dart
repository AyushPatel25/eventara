import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/past_ticket.dart';
import 'package:eventapp/componets/snack_bar.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/feedback_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final FeedBackController feedBackController = Get.put(FeedBackController());
  
  void submitFeedback() {
    feedBackController.saveFeedBack(feedBackController.rating.value, feedBackController.textEditingController.text);
    
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.greyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(Assets.imagesStarLottie,
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 10,),
              TextStyleHelper.CustomText(
                  text: "Submitted",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: Assets.fontsPoppinsBold
              ),
              SizedBox(height: 5,),
              TextStyleHelper.CustomText(
                  text: "Thanks for your feedback!",
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: Assets.fontsPoppinsBold
              ),
              SizedBox(height: 10,),
              CustomButton(label: "OK", onPressed: (){Get.back();})
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
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
                fontFamily: Assets.fontsPoppinsBold
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
                        child: Image(
                          image: AssetImage(Assets.imagesPoster),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Center(
                      child: TextStyleHelper.CustomText(
                        text: "What is you rate?",
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: Assets.fontsPoppinsBold
                      ),
                    ),

                    SizedBox(height: 10,),

                    RatingBar.builder(
                      itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                        direction: Axis.horizontal,
                        minRating: 1,
                        itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber.withOpacity(0.8),),
                        onRatingUpdate: (value) {

                        }
                    ),

                    SizedBox(height: 20,),

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

                    SizedBox(height: 10,),

                    TextField(
                      cursorColor: AppColors.whiteColor,
                      maxLines: 4,
                      minLines: 3,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.lightGrey),),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.lightGrey),),
                        hintText: "Write your feedback",
                        hintStyle: TextStyle(color: AppColors.lightGrey,
                            fontFamily: 'regular'),
                        filled: true,
                        fillColor: AppColors.greyColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.lightGrey),
                        ),
                    )
                    ),

                    SizedBox(height: 40,),

                    CustomButton(
                        label: "Send feedback",
                        onPressed: (){
                          submitFeedback();
                        }
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
