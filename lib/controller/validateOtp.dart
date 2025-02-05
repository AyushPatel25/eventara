
import 'package:eventapp/componets/snack_bar.dart';
import 'package:get/get.dart';

import '../view/user/location_acc.dart';


const String correctPin = '123456';
void validateOtp(String pin){
  if(pin == correctPin)
    {
      Get.offAll(Location());
    }
  else
    {
      Get.closeAllSnackbars();
      mySnackBar("Please enter a valid OTP");
    }

}
