// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:newsweb/page_routes/routes.dart';
// import 'package:newsweb/utils/appimage.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:screenshot/screenshot.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<StatefulWidget> createState() => InitState();
// }

// class InitState extends State<SplashScreen> {

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   startTimer() async {
//     var duration = const Duration(seconds: 2);
//     return Timer(duration, homePageRoute);
//   }

//   homePageRoute() async
//   {

//     Navigator.of(context).pushNamedAndRemoveUntil(
//         Routes.dashBoardScreenActivity, (Route<dynamic> route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           alignment: Alignment.center,
//           clipBehavior: Clip.none,
//           children: [
//             SizedBox(
//               height: 100.h,
//               width: 100.w,
//               child: Image.asset(
//                 AppImages.welcomescreenillimage,
//                 fit: BoxFit.fill,
//               ),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsweb/view/auth/login.dart';
import 'package:newsweb/view/ui/home_screen.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) 
        {
          return DashBoardScreenActivity();
        }
        return LoginScreen();
      },
    );
  }
}
