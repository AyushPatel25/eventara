import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackController extends GetxController{
  var rating = 0.0.obs;
  var comment = ''.obs;
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFeedback();
  }

  Future<void> saveFeedBack(double rate, String text) async{
    rating.value = rate;
    comment.value = text;
    textEditingController.text = text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("rating", rate);
    await prefs.setString("comment", text);
  }

  Future<void> loadFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rating.value = prefs.getDouble("rating") ?? 0.0;
    comment.value = prefs.getString("comment") ?? '';
    textEditingController.text = comment.value;
  }
}