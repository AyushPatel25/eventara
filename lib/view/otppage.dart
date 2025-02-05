import 'package:eventapp/componets/otp_pinput.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/validateOtp.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/utills/stringconstant.dart';
import 'package:eventapp/view/login.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../componets/button.dart';
import '../componets/snack_bar.dart';
import '../controller/OTPTimer_cont.dart';

class Otppage extends StatelessWidget {
  Otppage({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final OtpController otpController = Get.put(OtpController());

    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,

          systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          systemNavigationBarColor: Colors.black,
          ),

          title: TextStyleHelper.CustomText(
              text: CustomString().otpApp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
              fontFamily: Assets.fontsPoppinsBold),
          leading: IconButton(
              onPressed: () {
                Get.to(LoginPage());
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),

          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 30),
              TextStyleHelper.CustomText(
                  text: 'We have sent a verification code to '
                      '$email',
                  color: AppColors.lightGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: Assets.fontsPoppinsBold),

              const SizedBox(height: 30),

              myPinPut(),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextStyleHelper.CustomText(
                    text: CustomString().otpNot,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(() {
                        return otpController.resendTime.value != 0
                            ? TextStyleHelper.CustomText(
                          text: 'Resend(00:${otpController.resendTime.value.toString().padLeft(2, '0')})',
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: Assets.fontsPoppinsBold,
                        ) : SizedBox();
                      }),

                      Obx(() {
                        return otpController.resendTime.value == 0
                            ? InkWell(
                          onTap: () {
                            otpController.resetTimer();
                          },
                          child: TextStyleHelper.CustomText(
                            text: CustomString().otpRe,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: Assets.fontsPoppinsBold,
                          ),
                        ) : SizedBox();
                      }),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 50),
              SingleChildScrollView(

                child: CustomButton(
                  label: 'Continue',
                  onPressed: (){
                    String currentPin = otpController.otp.value; // Get the current value of the PIN
                    if (currentPin.length < 6) {
                      Get.closeAllSnackbars();
                      mySnackBar("Please enter a valid OTP");
                    } else {
                      validateOtp(currentPin);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
