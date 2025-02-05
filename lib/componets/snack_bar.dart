import 'package:eventapp/componets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../generated/assets.dart';
import '../utills/appcolors.dart';

void mySnackBar(String text){
  Get.snackbar(
      'Error',
      '',
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      borderRadius: 8,
      messageText: TextStyleHelper.CustomText(
          text: text,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w100,
          fontSize: 16,
          fontFamily: Assets.fontsPoppinsRegular),
  );
}