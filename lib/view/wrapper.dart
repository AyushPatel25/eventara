// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class _wrapperState extends StatefulWidget {
//   const _wrapperState({super.key});
//
//   @override
//   State<_wrapperState> createState() => _wrapperStateState();
// }
//
// class _wrapperStateState extends State<_wrapperState> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context,snapshot){
//             if(snapshot.hasData){
//               return;
//             }else{
//               return;
//             }
//           }
//       ),
//     );
//   }
// }
