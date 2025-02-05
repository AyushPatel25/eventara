import 'package:get/get.dart';

class FilterController extends GetxController{
  RxMap<String, bool> selectedFilters = <String, bool>{
    'Concert' : false,
    'Comedy' : false,
    'Sport' : false,
    'Party' : false,
    'Show' : false,
  }.obs;
}