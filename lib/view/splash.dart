import 'dart:async';

import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), (){

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(),));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(child: TextStyleHelper.CustomText(text: 'Event App',
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 40,
            fontFamily: Assets.fontsPoppinsBold)),
      ),
    );
  }
}