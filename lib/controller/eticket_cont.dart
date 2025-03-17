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
import 'package:fluttertoast/fluttertoast.dart';

import '../componets/text_style.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class EticketController extends GetxController {
  final ScreenshotController screenshotController = ScreenshotController();
  final EventController eventController = EventController();

  // Make arguments reactive to handle potential null values
  final Rx<Map<String, dynamic>> ticketData = Rx<Map<String, dynamic>>({});

  // Loading state for operations
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Safely handle arguments
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      ticketData.value = Map<String, dynamic>.from(Get.arguments);
      print("Ticket data received: ${ticketData.value}");
    } else {
      print("No ticket data received or invalid format");
      // Show error with slight delay to ensure UI is built
      Future.delayed(Duration(milliseconds: 300), () {
        showToast("Ticket details not found. Please try again.", isError: true);
        // Navigate back after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Get.back();
        });
      });
    }
  }

  // Helper method to show toast
  void showToast(String message, {bool isError = false}) {
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

  // Check if we have valid ticket data
  bool get hasValidTicketData {
    return ticketData.value.isNotEmpty &&
        ticketData.value.containsKey('eventName') &&
        ticketData.value.containsKey('ticketNumbers');
  }

  // Take screenshot and prepare for sharing
  Future<Uint8List?> captureTicket() async {
    try {
      if (!hasValidTicketData) {
        showToast("Invalid ticket data", isError: true);
        return null;
      }

      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        showToast("Failed to capture ticket image", isError: true);
      }
      return imageBytes;
    } catch (e) {
      print("Error capturing ticket: $e");
      showToast("Failed to capture ticket: $e", isError: true);
      return null;
    }
  }

  // Save and share ticket
  Future<void> saveAndShare() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final Uint8List? imageBytes = await captureTicket();
      if (imageBytes == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/ticket_screenshot.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await shareTicket(filePath);
    } catch (e) {
      print("Error in saveAndShare: $e");
      showToast("Failed to save and share: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Share ticket from file path
  Future<void> shareTicket(String filePath) async {
    try {
      if (!hasValidTicketData) {
        showToast("Invalid ticket data", isError: true);
        return;
      }

      XFile xFile = XFile(filePath);
      final eventName = ticketData.value['eventName'] ?? 'Event';

      await Share.shareXFiles(
          [xFile],
          text: "Check out my ticket for $eventName on Eventara!",
          subject: "$eventName E-Ticket"
      );
    } catch (e) {
      print("Error in shareTicket: $e");
      showToast("Failed to share the ticket: $e", isError: true);
    }
  }

  // Share event poster
  Future<void> shareImage() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (!hasValidTicketData) {
        showToast("Invalid event data", isError: true);
        return;
      }

      // Load the asset as a byte array
      final byteData = await rootBundle.load(Assets.imagesPoster);
      final buffer = byteData.buffer.asUint8List();

      // Get a temporary directory to store the file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/poster.png');

      // Write the asset data to the temporary file
      await tempFile.writeAsBytes(buffer);

      final eventName = ticketData.value['eventName'] ?? 'Event';

      // Share the file
      await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: 'Check out $eventName on Eventara!',
          subject: 'Eventara: $eventName'
      );
    } catch (e) {
      print("Error in shareImage: $e");
      showToast("Failed to share image: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Capture and save ticket to device
  Future<void> captureAndSave() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (!hasValidTicketData) {
        showToast("Invalid ticket data", isError: true);
        return;
      }

      // Request storage permission on Android
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            showToast("Storage permission is required to save the ticket", isError: true);
            return;
          }
        }
      }

      // Show in-progress toast
      Fluttertoast.showToast(
        msg: "Saving ticket...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      // Capture the screenshot
      Uint8List? imageBytes = await captureTicket();
      if (imageBytes == null) return;

      // Get the appropriate directory
      Directory? directory;
      String filePath;

      if (Platform.isAndroid) {
        // For Android, try to use the Downloads folder
        if (await Directory("/storage/emulated/0/Download").exists()) {
          directory = Directory("/storage/emulated/0/Download");
        } else {
          // Fallback to app's documents directory
          directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }

        // Get event name or use default
        final eventName = ticketData.value['eventName'] ?? 'event';
        filePath = "${directory.path}/${eventName.replaceAll(' ', '_')}_eticket.png";
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        final eventName = ticketData.value['eventName'] ?? 'event';
        filePath = "${directory.path}/${eventName.replaceAll(' ', '_')}_eticket.png";
      } else {
        showToast("Unsupported platform", isError: true);
        return;
      }

      if (directory == null) {
        showToast("Failed to get storage directory", isError: true);
        return;
      }

      // Write the file
      File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      print("File saved at: $filePath");

      // Show success toast
      showToast("Ticket downloaded successfully to Downloads folder!");

    } catch (e) {
      print("Error in captureAndSave: $e");
      showToast("Failed to save image: ${e.toString()}", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}