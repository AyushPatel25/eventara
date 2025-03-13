import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/view/organizer/organizer_dashboard.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
    };
  }
}

class OrganizerModel {
  final String uid;
  final String organizerName;
  final String organizerEmail;
  final Map<String, dynamic> events;

  OrganizerModel({
    required this.uid,
    required this.organizerName,
    required this.organizerEmail,
    this.events = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "organizerName": organizerName,
      "organizerEmail": organizerEmail,
      "events": events,
    };
  }

  factory OrganizerModel.fromJson(Map<String, dynamic> json) {
    return OrganizerModel(
      uid: json['uid'] ?? '',
      organizerName: json['organizerName'] ?? '',
      organizerEmail: json['organizerEmail'] ?? '',
      events: json['events'] != null ? Map<String, dynamic>.from(json['events']) : {},
    );
  }
}

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final GetStorage box = GetStorage();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController organizationNameController = TextEditingController();
  final RxBool isLoading = false.obs;

  final RxString selectedUserType = "Audience".obs;

  void setUserType(String type) {
    selectedUserType.value = type;
  }

  Future<void> signup() async {
    if (signupFormKey.currentState == null || !signupFormKey.currentState!.validate()) {
      Get.snackbar("Validation Error", "Please fill in all fields correctly", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String userType = selectedUserType.value;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "All fields are required", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;

      if (user != null) {
        if (userType == "Audience") {
          UserModel newUser = UserModel(
            uid: user.uid,
            username: username,
            email: email,
          );
          await firestore.collection("users").doc(user.uid).set(newUser.toJson());

          box.write('isLoggedIn', true);
          box.write('uid', user.uid);
          box.write('username', username);
          box.write('email', email);
          box.write('userType', "Audience");

          Get.offAll(Location());
        } else {
          // Generate a new unique OID
          String organizationName = organizationNameController.text.trim();

          // Save organizer details
          OrganizerModel newOrganizer = OrganizerModel(
            uid: user.uid, // Use generated oid
            organizerName: organizationName.isNotEmpty ? organizationName : username,
            organizerEmail: email,
          );
          await firestore.collection("organizers").doc(user.uid).set(newOrganizer.toJson());

          // Store organizer details in GetStorage
          box.write('isLoggedIn', true);
          box.write('uid', user.uid);
          box.write('organizerName', organizationName.isNotEmpty ? organizationName : username);
          box.write('organizerEmail', email);
          box.write('userType', "Organizer");

          Get.offAll(OrganizerDashboard());
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Sign Up Error", e.message ?? "An error occurred", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    organizationNameController.dispose();
    super.onClose();
  }
}
