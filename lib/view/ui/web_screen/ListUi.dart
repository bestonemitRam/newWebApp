import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsweb/model/dashboard_model.dart';
import 'package:newsweb/utils/custom_alertDialog.dart';
import 'package:newsweb/view_model/controller/dashboard_controller.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListUi extends StatefulWidget {
  DashBoardModel item;
  ListUi(this.item);

  @override
  State<ListUi> createState() => _ListUiState();
}

class _ListUiState extends State<ListUi> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RetailerController myController = Get.put(RetailerController());

  void deleteDocument(String documentId) async {
    try {
      DocumentReference docRef =
          firestore.collection("shortnews").doc(documentId);

      await docRef.delete();
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomAlertDialog('Deleted successfully'),
          );
        },
      );
      myController.fetchData();
    } catch (e) {
      print('Failed to delete document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20.w,
                height: 11.h,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.item.img.toString(),
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, url, error) => Icon(Icons.error),
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.item.title.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.item.description.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        '${timeago.format(DateTime.parse(widget.item.created_date.split(" ").first))}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        deleteDocument(widget.item.news_id);
                      });
                    },
                    icon: Icon(Icons.delete_forever_rounded),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
