import 'dart:io';
import 'dart:typed_data';
import 'package:eventapp/componets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../componets/text_style.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class EticketController extends GetxController {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveAndShare() async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        Get.snackbar("Error", "Failed to capture image!");
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/ticket_screenshot.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await shareTicket(filePath);
    } catch (e) {
      Get.snackbar("Error", "Failed to save and share: $e");
    }
  }

  Future<void> shareTicket(String filePath) async {
    try {
      XFile xFile = XFile(filePath);
      await Share.shareXFiles([xFile], text: "Check out this!");
    } catch (e) {
      Get.snackbar("Error", "Failed to share the ticket: $e");
    }
  }

  Future<void> shareImage() async {
    // Load the asset as a byte array
    final byteData = await rootBundle.load(Assets.imagesPoster);
    final buffer = byteData.buffer.asUint8List();

    // Get a temporary directory to store the file
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/poster.png');

    // Write the asset data to the temporary file
    await tempFile.writeAsBytes(buffer);

    // Share the file
    Share.shareXFiles([XFile(tempFile.path)], text: 'Great picture');
  }

  Future<void> captureAndSave() async {
    try {
      // Request permissions (Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          mySnackBar("Storage access is required!");
          return;
        }
      }

      Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes == null) {
        mySnackBar("Failed to capture image!");
        return;
      }

      // Get Download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        Get.snackbar("Error", "Failed to get directory!");
        mySnackBar("Failed to get directory!");
        return;
      }

      String filePath = "${directory.path}/ticket.png";
      File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      //Get.snackbar("Success", "Image saved at: $filePath");
      Get.snackbar(
        'Success',
        '',
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: AppColors.whiteColor,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        borderRadius: 8,
        messageText: TextStyleHelper.CustomText(
            text: "Image downloaded",
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w100,
            fontSize: 16,
            fontFamily: Assets.fontsPoppinsRegular),
      );
    } catch (e) {
      mySnackBar("Failed to capture image!");
    }
  }
}
