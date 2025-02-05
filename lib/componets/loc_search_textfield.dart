import 'package:flutter/material.dart';

import '../utills/appcolors.dart';

Widget locTextFormField({
  String? hintText,
  TextEditingController? controller,
  Function(String)? onChanged,
  valaidator,
}){
  return TextField(
    cursorColor: AppColors.whiteColor,
    controller: controller,
    keyboardType: TextInputType.text,
    onChanged: onChanged,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.whiteColor),),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.whiteColor),),
        prefixIcon: Icon(Icons.pin_drop_outlined, color: AppColors.whiteColor),
        hintText: 'Seach your location',
        hintStyle: TextStyle(color: Colors.grey,
            fontFamily: 'regular'),
        filled: true,
        fillColor: AppColors.greyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),

    ),

  );
}