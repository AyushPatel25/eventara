import 'package:get/get.dart';

class CounterController extends GetxController{
  RxInt n = 1.obs;

  void increase(){
    n++;
  }

  void decrease(){
    if(n > 1){
      n--;
    }
  }
}