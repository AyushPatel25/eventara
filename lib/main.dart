import 'package:eventapp/view/home/dashboard_binding.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/home/home_page.dart';
import 'package:eventapp/view/login.dart';
import 'package:eventapp/view/otppage.dart';
import 'package:eventapp/view/splash.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventApp Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      /*initialRoute: "/",
      getPages: [
        GetPage(
            name: "/", page: ()=>Location(),
            binding:  DashboardBinding()
        ),

        GetPage(
            name: "/", page: ()=>DashboardPage(),
            binding: DashboardBinding()
        )
      ],*/
      home: LoginPage(),
    );
  }
}



