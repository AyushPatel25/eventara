import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/view/home/dashboard_binding.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/home_page.dart';
import 'package:eventapp/view/login.dart';
import 'package:eventapp/view/organizer/organizer_dashboard.dart';
import 'package:eventapp/view/otppage.dart';
import 'package:eventapp/view/splash.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(

    MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();

  Future<Widget> _checkLoginStatus() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      DocumentSnapshot orgDoc = await _firestore.collection('organizers').doc(user.uid).get();

      if (userDoc.exists) {
        box.write('isLoggedIn', true);
        box.write('uid', user.uid);
        box.write('username', userDoc['username']);
        box.write('email', userDoc['email']);
        box.write('userType', 'Audience');
        return DashboardPage();
      }
      else if (orgDoc.exists) {
        box.write('isLoggedIn', true);
        box.write('uid', user.uid);
        box.write('organizerName', orgDoc['organizerName']);
        box.write('organizerEmail', orgDoc['organizerEmail']);
        box.write('userType', 'Organizer');
        return OrganizerDashboard();
      }
    }
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = box.read('isLoggedIn') ?? false;
    String? userType = box.read('userType');

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventApp Demo',
      theme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: FutureBuilder<Widget>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          if (isLoggedIn) {
            if (userType == 'Organizer') {
              return OrganizerDashboard();
            } else {
              return DashboardPage();
            }
          }
          return LoginPage();
        },
      ),
      initialBinding: DashboardBinding(),
    );
  }
}



