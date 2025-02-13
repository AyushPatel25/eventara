import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var favoriteEvents = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavouriteEvents();
  }


  void fetchFavouriteEvents() async {
    String userId = auth.currentUser?.uid ?? "";

    if (userId.isEmpty) return;

    var favDoc = await firestore.collection('users').doc(userId).get();
    if (favDoc.exists && favDoc.data()?['favorites'] != null) {
      favoriteEvents.value = List<String>.from(favDoc.data()?['favorites']);
    }
  }

  void toggleFavourite(String eventId) async {
    String userId = auth.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    var userRef = firestore.collection('users').doc(userId);

    if (favoriteEvents.contains(eventId)) {
      favoriteEvents.remove(eventId);
      await userRef.update({
        'favorites': FieldValue.arrayRemove([eventId])
      });
    } else {
      favoriteEvents.add(eventId);
      await userRef.set({'favorites': FieldValue.arrayUnion([eventId])}, SetOptions(merge: true));
    }
  }
}
