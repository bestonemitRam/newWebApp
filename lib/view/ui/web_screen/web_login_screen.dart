import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsweb/main.dart';
import 'package:newsweb/page_routes/routes.dart';
import 'package:newsweb/utils/app_string.dart';
import 'package:newsweb/utils/appimage.dart';
import 'package:newsweb/utils/colors.dart';
import 'package:newsweb/utils/my_progress_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:universal_html/html.dart' as html;

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final phoneController = TextEditingController();
  bool _validate = false;
  String message = 'Please Enter your phone number';
  bool isloading = false;
  bool isSendOtp = true;
  String _finalotp = '';
  var verificationIds;

  void saveUserDataInCookies(User user) {
    html.document.cookie = 'userID=${user.uid}; path=/';
    html.document.cookie = 'userPhone=${user.phoneNumber}; path=/';
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: isSendOtp
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.10),
                      child: Container(
                        width: size.width * 0.40,
                        child: Image.asset(
                          AppImages.welcomescreenillimage,

                          fit: BoxFit.fill,
                          //  width: 30.w,
                          // height: 10.h,
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 5.w,
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        // shape: StadiumBorder(

                        //   side: BorderSide(
                        //     color: Colors.black,
                        //     width: 2.0,
                        //   ),
                        // ),
                        child: Container(
                          width: size.width * 0.25,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, left: 5.w, right: 5.w, bottom: 10.h),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "     Contact",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14.sp),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        width: size.width * 0.80,
                                        // width: 20,
                                        height: 55,
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(28)),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Form(
                                            child: TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Enter phone number',
                                              hintStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.sp)),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp),
                                        ))),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                isloading
                                    ? myProgressBar()
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.amber)),
                                        onPressed: () async {
                                          if (!phoneController.text.isEmpty) {
                                            setState(() {
                                              isloading = true;
                                            });

                                            await FirebaseAuth.instance
                                                .verifyPhoneNumber(
                                              phoneNumber:
                                                  "+91 " + phoneController.text,
                                              timeout:
                                                  const Duration(seconds: 45),
                                              verificationCompleted:
                                                  (phoneAuthCredential) {},
                                              verificationFailed: (error) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter valid phone number ",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        AppColors.primarycolor,
                                                    fontSize: 16.0);
                                                setState(() {
                                                  isloading = false;
                                                  _validate = true;
                                                  message =
                                                      "Please Enter Valid Number";
                                                });
                                                log(error.toString());
                                              },
                                              codeSent: (verificationId,
                                                  forceResendingToken) {
                                                setState(() {
                                                  isSendOtp = false;
                                                  isloading = false;

                                              
                                                  verificationIds =
                                                      verificationId;
                                                });
                                              },
                                              codeAutoRetrievalTimeout:
                                                  (verificationId) {
                                                log("Auto Retireval timeout");
                                              },
                                            );
                                          } else {
                                            setState(() {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Enter phone number ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      AppColors.primarycolor,
                                                  fontSize: 16.0);
                                            });
                                          }
                                        },
                                        child: SizedBox(
                                            height: 50,
                                            width: size.width * 0.68,
                                            child: Center(
                                                child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            )))),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.10),
                      child: Container(
                        width: size.width * 0.40,
                        child: Image.asset(
                          AppImages.welcomescreenillimage,

                          fit: BoxFit.fill,
                          //  width: 30.w,
                          // height: 10.h,
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 5.w,
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        // shape: StadiumBorder(

                        //   side: BorderSide(
                        //     color: Colors.black,
                        //     width: 2.0,
                        //   ),
                        // ),
                        child: Container(
                          width: size.width * 0.25,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, left: 5.w, right: 5.w, bottom: 10.h),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "OTP Verify",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    PinCodeTextField(
                                      appContext: context,
                                      length: 6,
                                      obscureText: false,
                                      cursorColor: AppColors.blackColor,
                                      //animationType: AnimationType.fade,

                                      pastedTextStyle: TextStyle(
                                        color: AppColors.primarycolor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        disabledColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(1.h),
                                        fieldHeight: 50.w / 20,
                                        fieldWidth: 50.w / 23,
                                        activeFillColor: AppColors.primarycolor,
                                        // Theme.of(context).colorScheme.primary,12

                                        inactiveColor:
                                            AppColors.secondprimarycolor,
                                        inactiveFillColor: AppColors.whiteColor,
                                        selectedFillColor: AppColors.whiteColor,
                                        selectedColor: AppColors.primarycolor,
                                        activeColor: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor,
                                      ),

                                      animationDuration:
                                          Duration(milliseconds: 300),
                                      enableActiveFill: true,
                                      onCompleted: (v) {
                                        _finalotp = v;
                                      },
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      beforeTextPaste: (text) {
                                        return true;
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                isloading
                                    ? myProgressBar()
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.amber)),
                                        onPressed: () async {
                                          if (_finalotp != '') {
                                            setState(() {
                                              isloading = true;
                                            });
                                            try {
                                              final cred =
                                                  PhoneAuthProvider.credential(
                                                      verificationId:
                                                          verificationIds,
                                                      smsCode: _finalotp);

                                              var iin = await FirebaseAuth
                                                  .instance
                                                  .signInWithCredential(cred);

                                              final FirebaseAuth _auth =
                                                  FirebaseAuth.instance;
                                              User? user = _auth.currentUser;

                                              AppStringFile.USER_ID =
                                                  user!.uid.toString();
                                              await sharedPref.setString(
                                                  AppStringFile.USER_ID,
                                                  user!.uid.toString());
                                              await sharedPref.setString(
                                                  AppStringFile.USER_MOBILE,
                                                  user.phoneNumber ?? '');

                                              saveUserDataInCookies(user);

                                              Navigator.pushNamed(
                                                  context,
                                                  Routes
                                                      .dashBoardScreenActivity);
                                            } catch (e) {
                                              log(e.toString());
                                            }
                                            setState(() {
                                              isloading = false;
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Please Etter otp ",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    AppColors.primarycolor,
                                                fontSize: 16.0);
                                          }
                                        },
                                        child: SizedBox(
                                            height: 50,
                                            width: size.width * 0.68,
                                            child: Center(
                                                child: Text(
                                              'CONTINUE',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold),
                                            )))),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
