import 'dart:io';
import 'dart:typed_data';
import 'package:eventapp/componets/snack_bar.dart';
import 'package:eventapp/controller/myevent_cont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this import

import '../componets/text_style.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class EticketController extends GetxController {
  final ScreenshotController screenshotController = ScreenshotController();
  final EventController eventController = EventController();

  final arguments = Get.arguments;

  // Helper method to show toast
  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: AppColors.whiteColor,
        fontSize: 16.0
    );
  }

  Future<void> saveAndShare() async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        _showToast("Failed to capture image!", isError: true);
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/ticket_screenshot.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await shareTicket(filePath);
    } catch (e) {
      _showToast("Failed to save and share: $e", isError: true);
    }
  }

  Future<void> shareTicket(String filePath) async {
    try {
      XFile xFile = XFile(filePath);
      await Share.shareXFiles([xFile], text: "Check out this! E-ticket of ${arguments['eventName']} event");
    } catch (e) {
      _showToast("Failed to share the ticket: $e", isError: true);
    }
  }

  Future<void> shareImage() async {
    try {
      // Load the asset as a byte array
      final byteData = await rootBundle.load(Assets.imagesPoster);
      final buffer = byteData.buffer.asUint8List();

      // Get a temporary directory to store the file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/poster.png');

      // Write the asset data to the temporary file
      await tempFile.writeAsBytes(buffer);

      // Share the file
      await Share.shareXFiles([XFile(tempFile.path)], text: 'Check out ${arguments['eventName']} on Eventara!');
    } catch (e) {
      _showToast("Failed to share image: $e", isError: true);
    }
  }

  Future<void> captureAndSave() async {
    try {
      // Request permission only if necessary
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          _showToast("Storage permission is required to save the ticket", isError: true);
          return;
          // if (!status.isGranted) {
          //   _showToast("Storage permission is required to save the ticket", isError: true);
          //   return;  // Exit the function if permission is denied
          // }
        }
      }

      Fluttertoast.showToast(
        msg: "Saving ticket...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 3,
      );

      Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes == null) {
        _showToast("Failed to capture image", isError: true);
        return;
      }

      Directory? directory;
      if (Platform.isAndroid) {
        // For Android 10 (API level 29) and above, use getExternalStorageDirectory
        if (await Directory("/storage/emulated/0/Download").exists()) {
          directory = Directory("/storage/emulated/0/Download");
        } else {
          // Fallback to app's documents directory
          directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        _showToast("Failed to get storage directory", isError: true);
        return;
      }

      String filePath = "${directory.path}/${arguments['eventName']}_eticket.png";
      File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      print("File saved at: $filePath");

      // Show success toast
      _showToast("Ticket downloaded successfully!");

    } catch (e) {
      // Show error with more details
      _showToast("Failed to save image: ${e.toString()}", isError: true);
    }
  }
}