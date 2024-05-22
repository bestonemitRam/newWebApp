import 'package:flutter/material.dart';
import 'package:newsweb/page_routes/routes.dart';
import 'package:newsweb/utils/appimage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Image.asset(
                  AppImages.welcomescreenillimage,
                  fit: BoxFit.fill,
                  width: 30.w,
                  height: 10.h,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "     Contact",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: size.width * 0.80,
                        height: 55,
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(28)),
                            border: Border.all(color: Colors.white)),
                        child: Form(
                            child: TextFormField(
                          // controller: controller.mobileController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter phone number ',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 13)),
                          style: const TextStyle(color: Colors.white),
                        ))),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                    onPressed: () 
                    {
                        Navigator.pushNamed(
                                  context, Routes.dashBoardScreenActivity);
                            

                    },
                    child: SizedBox(
                        height: 50,
                        width: size.width * 0.68,
                        child: const Center(
                            child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )))),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}
