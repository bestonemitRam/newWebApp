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

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final RetailerController controller = Get.put(RetailerController());

  @override
  Widget build(BuildContext context) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: size.width / 3.8,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(28)),
                                      border: Border.all(
                                          color: AppHelper.themelight
                                              ? Colors.white
                                              : AppHelper.themelight
                                                  ? Colors.white
                                                  : Colors.black)),
                                  child: TextFormField(
                                    controller: controller.titleController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter news title ',
                                        hintStyle: TextStyle(
                                            color: AppHelper.themelight
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.sp)),
                                    style: TextStyle(
                                        color: AppHelper.themelight
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 14.sp),
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Enter Title ";
                                      }
                                      return null;
                                    },
                                  )),
                              SizedBox(
                                height: 2.h,
                              ),
                              ElevatedButton(
                                onPressed: () => controller.selectvideo(),
                                child: SizedBox(
                                  width: size.width / 4.2,
                                  child: Padding(
                                    padding: EdgeInsets.all(size.height * 0.02),
                                    child: Text('Browse video'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              if (controller.fileName.value != '')
                                Container(
                                  child: Container(
                                      child: Text(controller.fileName.value)),
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
                                    if (controller
                                        .titleController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter title !",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    } else if (controller.fileName.toString() ==
                                        "") {
                                      Fluttertoast.showToast(
                                          msg: "Please select image or video !",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    } else {
                                      controller.addVideo(context);
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
