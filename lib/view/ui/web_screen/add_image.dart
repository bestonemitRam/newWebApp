import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:js';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:newsweb/page_routes/routes.dart';
import 'package:newsweb/utils/apphelper.dart';
import 'package:newsweb/utils/appimage.dart';
import 'package:newsweb/view_model/controller/dashboard_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddImagScreen extends StatefulWidget {
  const AddImagScreen({super.key});

  @override
  State<AddImagScreen> createState() => _AddImagScreenState();
}

class _AddImagScreenState extends State<AddImagScreen> {
  final RetailerController controller = Get.put(RetailerController());

  @override
  Widget build(BuildContext context) 
  {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
                padding: EdgeInsets.only(
                    top: 5.h, left: 5.w, right: 5.w, bottom: 5.h),
                child: Obx(() => Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Upload Video",
                              style: TextStyle(
                                  color: AppHelper.themelight
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              controller.imageBytes.value == null
                                  ? InkWell(
                                      onTap: () => controller.selectImage(),
                                      child: Container(
                                          // width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.red)),
                                          width: size.width / 4,
                                          height: size.height * 0.15,
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  size.height * 0.02),
                                              child: Text('Browse Banner'),
                                            ),
                                          )),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          // width: MediaQuery.of(context).size.width,
                                          width: size.width / 4,
                                          height: size.height * 0.15,
                                          child: Container(
                                            child: Image.memory(
                                              controller.imageBytes.value!,
                                              width: size.width / 4,
                                              height: size.height * 0.10,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 2.h,
                                            right: 0.5.w,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.camera_enhance_outlined,
                                                color: Colors.black,
                                              ),
                                              onPressed: () =>
                                                  controller.selectImage(),
                                            ))
                                      ],
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.amber)),
                                  onPressed: () async {
                                    if (controller.selectvideoOrImage.value
                                            .toString() ==
                                        "Image") {
                                      Fluttertoast.showToast(
                                          msg: "Please Select Banner !",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    } else {
                                      controller.addBanner(context);
                                    }
                                  },
                                  child: SizedBox(
                                      height: 5.h,
                                      width: size.width / 4,
                                      child: Center(
                                          child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold),
                                      )))),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
          ),
        ));
  }
}
