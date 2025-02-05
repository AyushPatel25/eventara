import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventDetailsController extends GetxController{

  final ScrollController scrollController = ScrollController();

  var isTitleVisible = RxBool(false);
  double titlePosition = 200;

  var currentLocation = Rx<Position?>(null);
  final destinationLocation = Coords(37.759392, -122.5107336);


  @override
  void onInit() {
    scrollController.addListener(() {
      if(scrollController.offset >= titlePosition){
        isTitleVisible.value = true;
      } else{
        isTitleVisible.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> getUserLocation() async{
    try{
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
        throw Exception("Location permission denied");
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        throw Exception("Location permission denied");
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation.value = position;
    }catch(e){
      print("Error getting");
    }
  }
  Future<void> openMaps() async{
    try{
      if(currentLocation.value != null){
        print("User location: ${currentLocation.value!.latitude}, ${currentLocation.value!.longitude}");
        final availableMaps = await MapLauncher.installedMaps;

        print("Available maps: $availableMaps");

        if(availableMaps.isNotEmpty){
          showModalBottomSheet(
            backgroundColor: Colors.black,
            context: Get.context!,
            builder: (BuildContext context) {
              return ListView.builder(
                itemCount: availableMaps.length,
                itemBuilder: (context, index) {
                  final map = availableMaps[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextStyleHelper.CustomText(
                            text: 'Open In',
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: Assets.fontsPoppinsRegular
                        ),
                        Divider(
                          color: AppColors.divider,
                          height: 10,
                        ),
                        ListTile(
                          title: TextStyleHelper.CustomText(
                              text: map.mapName,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            fontFamily: Assets.fontsPoppinsRegular
                          ),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 30.0,
                            width: 30.0,
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                            await map.showDirections(
                              origin: Coords(currentLocation.value!.latitude,
                                  currentLocation.value!.longitude),
                              destination: destinationLocation,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }else{
          print("no maps");
        }
      }else{
        print("user loc not availabele");
      }
    }catch(e){
      print("error to opening map");
    }


  }
}