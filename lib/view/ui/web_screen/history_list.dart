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
import 'package:newsweb/view/ui/web_screen/ListUi.dart';
import 'package:newsweb/view_model/controller/dashboard_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsHistory extends StatefulWidget {
  const NewsHistory({super.key});

  @override
  State<NewsHistory> createState() => _NewsHistoryState();
}

class _NewsHistoryState extends State<NewsHistory> {
  final RetailerController myController = Get.put(RetailerController());

  @override
  void initState() {
    myController.fetchData();

    super.initState();
  }

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
                child: Obx(() {
                  return Skeletonizer(
                    enabled: !myController.datafound.value,
                    enableSwitchAnimation: true,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: myController.myData.length,
                        itemBuilder: (ctx, index) {
                          var item = myController.myData[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListUi(item),
                          );
                        }),
                  );
                }))));
  }
}
