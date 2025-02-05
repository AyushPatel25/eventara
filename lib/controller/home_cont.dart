import 'package:get/get.dart';

class HomeController extends GetxController{
  static HomeController get instance => Get.find();
  final RxInt curousalCurrentIndex = 0.obs;

  var favoriteEvents = <int>{}.obs;

  var indexCategory = 0.obs;

  void updateCategory(int index) {
    indexCategory.value = index;
  }

  void updatePageIndecator(index){
    curousalCurrentIndex.value = index;
  }

  void toggleFavourite(int index){
    if(favoriteEvents.contains(index)){
      favoriteEvents.remove(index);
    }
    else{
      favoriteEvents.add(index);
    }
  }
}