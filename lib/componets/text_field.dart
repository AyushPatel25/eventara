import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String hintText;
  final bool? obscureText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final IconButton? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.icon,
    this.label,
    required this.hintText,
    this.obscureText,
    this.onTap,
    this.controller,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      onTap: onTap,
      cursorColor: AppColors.whiteColor,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.whiteColor),),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.whiteColor),),
        prefixIcon: Icon(icon, color: AppColors.whiteColor),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey,
                    fontFamily: 'regular'),
          suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.greyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.whiteColor,
          fontFamily: 'regular',
        )
      ),

    );
  }
}
