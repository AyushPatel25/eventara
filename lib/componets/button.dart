import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String label;
  //final IconData? icon;
  final VoidCallback onPressed;


  const CustomButton({
    Key? key,
    required this.label,
    //this.icon,
    required this.onPressed,
}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        //padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20)
        minimumSize: Size.fromHeight(43),
      ),
        onPressed: onPressed,
        //icon:Icon(icon, color: Colors.black) ,
        label: Text(
          label,
          style: TextStyle(color: Colors.black,fontFamily: 'bold', fontSize: 17),
          //style: TextStyleHelper.CustomText(text: label, color: Colors.black, fontWeight: FontWeight.w100, fontSize: 20),
        ),);
  }

}