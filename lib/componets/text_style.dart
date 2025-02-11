import 'package:flutter/material.dart';

class TextStyleHelper{
  static CustomText(
      {required String text,
        required Color color,
        required FontWeight fontWeight,
        String? fontFamily,
        required double fontSize,
        TextOverflow? overflow,
        int? maxLines}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily ?? "regular",
          fontWeight: fontWeight,
          color: color,
          overflow: overflow,
      ),
    );
  }
}