import 'dart:async';
import 'package:get/get.dart';

class OtpController extends GetxController {
  RxInt resendTime = 30.obs;
  var otp = ''.obs;
  late Timer countdownTimer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendTime.value = resendTime.value - 1;
      if (resendTime.value < 1) {
        countdownTimer.cancel();
      }
    });
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  void resetTimer() {
    resendTime.value = 30;
    startTimer();
  }
}
