import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapThemeController extends GetxController{
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
  }

  void onMapCreated(GoogleMapController themeController) async {
    mapController = themeController;
    String styleMap = await rootBundle.loadString("assets/images/darkmap.json");
    mapController!.setMapStyle(styleMap);
  }

}