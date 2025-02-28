import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/controller/auth_controller.dart';
import 'package:eventapp/controller/login_cont.dart';
import 'package:eventapp/controller/validateEmail.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/forgetpage.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:eventapp/view/organizer/organizer_dashboard.dart';
import 'package:eventapp/view/organizer/organizer_home.dart';
import 'package:eventapp/view/user/location_acc.dart';
import 'package:eventapp/view/user/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gif/gif.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../componets/button.dart';
import '../componets/text_field.dart';
import '../componets/text_style.dart';
import '../generated/assets.dart';
import '../utills/font_constant.dart';
import '../utills/stringconstant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late GifController _controller;
  //final FirebaseAuthService authService = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  final GetStorage box = GetStorage();

  final RxBool isLoading = false.obs;

  String _selectedUserType = "Audience";

  @override
  void dispose(){
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  //late AuthController authController;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.reset();
    });

    //authController = Get.put(AuthController());
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: height,
                width: width,
                color: Colors.black87,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Gif(
                        image: const AssetImage("assets/images/BackGif.gif"),
                        controller: _controller,
                        fit: BoxFit.cover,
                        autostart: Autostart.loop,
                        onFetchCompleted: () {
                          _controller.reset();
                          _controller.forward();
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              Assets.imagesApptitle,
                              height: 85,
                              width: 85,
                            ),
                            Center(
                              child: TextStyleHelper.CustomText(
                                text: "Let's Get Started",
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: FontSizes.heading2,
                                fontFamily: 'bold',
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Center(
                              child: TextStyleHelper.CustomText(
                                text: "Sign up or log in to see what's happening near you",
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: FontSizes.caption,
                                fontFamily: 'regular',
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [


                                ChoiceChip(
                                  label: TextStyleHelper.CustomText(
                                    text: "Audience",
                                    color: _selectedUserType== "Audience" ? Colors.black : AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'regular',
                                  ),
                                  showCheckmark: false,
                                  selectedColor: AppColors.primaryColor,
                                  selected: _selectedUserType == "Audience",
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedUserType = "Audience";
                                      Get.offAll(Location());
                                    });
                                  },
                                ),

                                const SizedBox(width: 10),

                                ChoiceChip(
                                  label: TextStyleHelper.CustomText(
                                    text: "Organizer",
                                    color: _selectedUserType== "Organizer" ? Colors.black : AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'regular',
                                  ),
                                  showCheckmark: false,
                                  selectedColor: AppColors.primaryColor,
                                  selected: _selectedUserType == "Organizer",
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedUserType = "Organizer";
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextField(
                              controller: _emailController,
                              icon: Icons.email_outlined,
                              hintText: CustomString().Email,
                            ),

                            const SizedBox(height: 10.0),
                            Obx(() => CustomTextField(
                              controller: _passwordController,
                              icon: Icons.lock,
                              hintText: "Enter your password",
                              obscureText: authController.hidePassword.value,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  authController.hidePassword.toggle();
                                },
                                icon: Icon(
                                  authController.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                                  color: AppColors.lightGrey,
                                ),
                              ),
                            )),



                            const SizedBox(height: 16.0),

                          Center(
                            child: InkWell(
                              onTap: () {
                                Get.to(Forgetpage());
                              },
                              child: TextStyleHelper.CustomText(
                                text: "Forgot Password?",
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: Assets.fontsPoppinsBold,
                              ),
                            ),
                          ),

                            const SizedBox(height: 16.0),
                            // Obx(() =>
                            // authController.isLoading.value? Center(child: CircularProgressIndicator(),)
                            //     /*:*/ CustomButton(
                            //     label: 'Continue',
                            //     onPressed: (){
                            //       validateEmail(
                            //         emailController: _emailController,
                            //         passwordController: _passwordController, // Pass password controller
                            //         context: context,
                            //         userType: _selectedUserType,
                            //         //authController: authController, // Pass AuthController
                            //       );

                                  //authController.login(email: _emailController.text.trim(), password: _passwordController.text.trim());
                        // CustomButton(
                        //     label: 'Continue',
                        //     onPressed: (){
                        //       validateEmail(
                        //         emailController: _emailController,
                        //         passwordController: _passwordController,
                        //         context: context,
                        //         userType: _selectedUserType,
                        //         //authController: authController,
                        //       );
                        //       _signIn();
                        //       // if(_selectedUserType == "Organizer"){
                        //       //   _signInOrganizer();
                        //       // }
                        //       // else if(_selectedUserType == "Audience"){
                        //       //   _signIn();
                        //       // }
                        //     }
                        //     ),
                            Obx(() => ElevatedButton(
                              onPressed: () {
                                validateEmail(
                                  emailController: _emailController,
                                  passwordController: _passwordController,
                                  context: context,
                                  userType: _selectedUserType,
                                            //authController: authController,
                                );
                                if(_selectedUserType == "Organizer"){
                                  _signInOrganizer();
                                }
                                else if(_selectedUserType == "Audience"){
                                  _signIn();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size.fromHeight(43),
                              ),
                              child: isLoading.value
                                  ? CircularProgressIndicator(color: Colors.black)
                                  : Text(
                                "Continue",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'bold',
                                    fontSize: 17
                                ),
                              ),
                            )),

                            const SizedBox(height: 16,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextStyleHelper.CustomText(
                                  text: "Does not have account?",
                                  color: AppColors.lightGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: Assets.fontsPoppinsBold,
                                ),

                                SizedBox(width: 10,),

                                InkWell(
                                  onTap: () {
                                    Get.to(SignUpPage());
                                  },
                                  child: TextStyleHelper.CustomText(
                                    text: "Sign Up",
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: Assets.fontsPoppinsBold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInOrganizer() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('organizers').doc(user.uid).get();

        if (userDoc.exists) {

          final box = GetStorage();
          box.write('isLoggedIn', true);
          box.write('oid', user.uid);
          box.write('organizerName', userDoc['organizerName']);
          box.write('organizerEmail', userDoc['organizerEmail']);

          Get.offAll(OrganizerDashboard());

          // if(_selectedUserType == "Organizer"){
          //   Get.offAll(DashboardPage());
          // }
          // else if(_selectedUserType == "Audience"){
          //   Get.offAll(() => Location());
          // }
        } else {
          Get.snackbar("Login Error", "User data not found in database",
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Invalid email or password",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    isLoading.value = true;

    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {

          final box = GetStorage();
          box.write('isLoggedIn', true);
          box.write('uid', user.uid);
          box.write('username', userDoc['username']);
          box.write('email', userDoc['email']);

          // Get.offAll(() => Location());

          if(_selectedUserType == "Organizer"){
            Get.offAll(OrganizerDashboard());
          }
          else if(_selectedUserType == "Audience"){
            Get.offAll(() => Location());
          }
        } else {
          Get.snackbar("Login Error", "User data not found in database",
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Invalid email or password",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

}
