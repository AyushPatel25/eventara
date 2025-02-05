import 'package:eventapp/controller/validateOtp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controller/OTPTimer_cont.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

const correctPin = '123456';

class myPinPut extends StatelessWidget {
  myPinPut({super.key});

  final TextEditingController pinController = TextEditingController();
  final OtpController otpController = Get.put(OtpController());


  @override
  Widget build(BuildContext context) {
    return Pinput(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      length: 6,
      autofocus: true,

      controller: pinController,

      focusedPinTheme: PinTheme(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryColor,
          ),
        ),
        textStyle: TextStyle(fontSize: 24, fontFamily: Assets.fontsPoppinsRegular),
      ),

      defaultPinTheme: PinTheme(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.whiteColor,
          ),
        ),
        textStyle: TextStyle(fontSize: 24, fontFamily: Assets.fontsPoppinsRegular),
      ),
      onChanged: (value){
        otpController.otp.value;
      },
      onCompleted: (value){
        validateOtp(value);
        //all value fill out on individule box then trigger

      },
      onSubmitted: (value){
        //when user click on yes button in keyboard then trigger
      },


      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,

    );
    ;
  }
}


