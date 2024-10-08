import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:newsweb/model/dashboard_model.dart';
import 'package:newsweb/services/data_service.dart';
import 'package:newsweb/utils/custom_alertDialog.dart';

class RetailerController extends GetxController {
  Rx<File?> imageFile = Rx<File?>(null);
  String selectedFile = '';
  var datafound = false.obs;

  final DataService _dataService = DataService();
  var myData = <DashBoardModel>[].obs;

  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> imageVideo = Rx<Uint8List?>(null);
  late Uint8List selectedImageInBytes;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }



    void fetchData() async 
    {
       datafound.value = false;
     myData.value = await _dataService.fetchData();
       datafound.value = true;
    }

  void selectImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
          // type: FileType.custom,
          //allowedExtensions: ['jpg', 'jpeg', 'png'],
          );

      if (result != null) {
        final file = result.files.first.bytes;
        selectedFile = result.files.first.name;
        selectedImageInBytes = result.files.first.bytes!;
        imageBytes.value = file;
      } else {
        print('User canceled image selection');
      }
    }
  }

  RxString fileName = ''.obs;
  void selectvideo() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4'],
      );

      if (result != null) {
        final fileanme = result.files.first;
        fileName.value = fileanme.name;
        final file = result.files.first.bytes;
        selectedFile = result.files.first.name;
        selectedImageInBytes = result.files.first.bytes!;
      } else {
        print('User canceled image selection');
      }
    }
  }

  RxBool isAddData = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController newsDescription = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController referenceURLController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  final List<String> language = [
    'Select Language ',
    'Hindi',
    'English',
  ].obs;
  final List<String> type = [
    'Select video or Image ',
    'Image',
    'Video',
  ].obs;

  RxString selectvideoOrImage = 'Select video or Image '.obs;

  RxString selectedValue = 'Select Language '.obs;

  final List<String> slectNewsType = [
    'Select News Type',
    'My Feed',
    'All News',
    'Trending',
    'Book Mark',
    'Technology',
    'Entertainment',
    'Sports',
  ].obs;
  RxString selectedtype = 'Select News Type'.obs;

  Future<String> uploadFile() async {
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('product')
          .child('/' + selectedFile);

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      //uploadTask = ref.putFile(File(file.path));
      uploadTask = ref.putData(selectedImageInBytes, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  Future<void> addData(BuildContext context) async {
    Get.context!.loaderOverlay.show();
    String imageUrl = await uploadFile();
    var now = DateTime.now();

    if (imageUrl != null) {
      FirebaseFirestore.instance.collection('shortnews').add({
        'description': newsDescription.text,
        'from': referenceController.text,
        'img': imageBytes.value != null ? imageUrl : '',
        'language': selectedValue.value == "Hindi" ? 'hi' : "en",
        'news_link': referenceURLController.text,
        'takenby': 'Ram',
        'title': titleController.text,
        'video': fileName.value != '' ? imageUrl : '',
        "newsType": selectedtype.value,
        "news_id": '',
        'created_date': now,
      }).then((DocumentReference documentReference) {
        // Get the generated document ID
        String documentId = documentReference.id;

        FirebaseFirestore.instance
            .collection('shortnews')
            .doc(documentId)
            .update({
          'news_id': documentId,
        }).then((_) {
          sendNotification(
              titleController.text, "notification", imageUrl, documentId, 1);
          newsDescription.clear();
          referenceController.clear();
          referenceURLController.clear();
          titleController.clear();
          //selectedtype.value = 'Select News Type';
          // selectedValue.value = 'Select Language';
          fileName.value = '';
          imageBytes.value = null;

          Get.context!.loaderOverlay.hide();
          Fluttertoast.showToast(
              msg: "Data added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: CustomAlertDialog('Data added successfully'),
              );
            },
          );
          print("Data added successfully !");
        }).catchError((error) {
          print("Failed to add data: $error");
        });
      }).catchError((error) {
        // Error adding data to Firestore
        print("Failed to add data: $error");
      });
    }
  }

  Future<void> addBanner(BuildContext context) async {
    Get.context!.loaderOverlay.show();
    String imageUrl = await uploadFile();
    var now = DateTime.now();

    if (imageUrl != null) {
      FirebaseFirestore.instance.collection('shortnews').add({
        'description': newsDescription.text,
        'from': referenceController.text,
        'img': imageBytes.value != null ? imageUrl : '',
        'language': "en",
        'news_link': referenceURLController.text,
        'takenby': 'Ram',
        'banner': "Yes",
        'title': '',
        'video': fileName.value != '' ? imageUrl : '',
        "newsType": "My Feed",
        "news_id": '',
        'created_date': now,
      }).then((DocumentReference documentReference) {
        String documentId = documentReference.id;

        FirebaseFirestore.instance
            .collection('shortnews')
            .doc(documentId)
            .update({
          'news_id': documentId,
        }).then((_) {
          sendNotification(
              titleController.text, "notification", imageUrl, documentId, 1);
          newsDescription.clear();
          referenceController.clear();
          referenceURLController.clear();
          titleController.clear();
          //selectedtype.value = 'Select News Type';
          // selectedValue.value = 'Select Language';
          fileName.value = '';
          imageBytes.value = null;

          Get.context!.loaderOverlay.hide();
          Fluttertoast.showToast(
              msg: "Data added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: CustomAlertDialog('Data added successfully'),
              );
            },
          );
          print("Data added successfully !");
        }).catchError((error) {
          print("Failed to add data: $error");
        });
      }).catchError((error) {
        // Error adding data to Firestore
        print("Failed to add data: $error");
      });
    }
  }

  Future<String> uploadVideoFile() async {
    String videoUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('videos')
          .child('/${fileName.value}');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'video/mp4');

      uploadTask = ref.putData(selectedImageInBytes, metadata);

      await uploadTask.whenComplete(() => null);
      videoUrl = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return videoUrl;
  }

  Future<void> addVideo(BuildContext context) async {
    Get.context!.loaderOverlay.show();
    String imageUrl = await uploadVideoFile();
    var now = DateTime.now();

    print("upload video  ${imageUrl}");

    if (imageUrl != null) {
      FirebaseFirestore.instance.collection('short_video').add({
        'video_url': fileName.value != '' ? imageUrl : '',
        'title': titleController.text,
        'created_date': now,
      }).then((DocumentReference documentReference) {
        print("uploaded");
        String documentId = documentReference.id;

        FirebaseFirestore.instance
            .collection('short_video')
            .doc(documentId)
            .update({
          'video_id': documentId,
        }).then((_) {
          fileName.value = '';
          imageBytes.value = null;
          titleController.clear();

          sendNotification(titleController.text, "Please watch video", imageUrl,
              documentId, 2);

          Get.context!.loaderOverlay.hide();
          Fluttertoast.showToast(
              msg: "Data added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: CustomAlertDialog('Data added successfully'),
              );
            },
          );
          print("Data added successfully !");
        }).catchError((error) {
          print("Failed to add data: $error");
        });
      }).catchError((error) {
        // Error adding data to Firestore
        print("Failed to add data: $error");
      });
    }
  }

  Future<void> sendNotification(String subject, String title, String image,
      String documentId, int type) async {
    var uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
    String toParams = "/topics/" + 'shotnews';
    print("kjdsfghkj  ${subject}  ${documentId}, ${type}");
    final data = {
      "notification": {"body": " ", "image": image, "title": subject},
      "priority": "high",
      "data": {
        "type": "${type}",
        "id": "${documentId}",
        "status": "done",
        "sound": 'default',
        "screen": "shotnews",
      },
      "to": "${toParams}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA-xgVGVU:APA91bHokNAYK3ypaPe-XyZXiqEDwatxrYpO7VCFvJ-nAEiYzMI4WZ8yM8yNlGU-uvn0w_Ckz7fptXwNR8kYHt-HpT1hKaQG9YuLiku3E3fe4UEfsYgvKHhyx5ZH-Cfa2W80WZsQUOZT'
    };

    final response = await http.post(uri,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
// on success do
      print("true");
    } else {
// on failure do
      print("false");
    }
  }
}
