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
import 'package:newsweb/utils/custom_alertDialog.dart';

class RetailerController extends GetxController
 {
  Rx<File?> imageFile = Rx<File?>(null);
  String selectedFile = '';

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

      if (result != null) 
      {
        final fileanme = result.files.first;
        fileName.value = fileanme.name;
        final file = result.files.first.bytes;
        selectedFile = result.files.first.name;
        selectedImageInBytes = result.files.first.bytes!;
      } else 
      {
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
        'takenby': 'value2',
        'title': titleController.text,
        'video': fileName.value != '' ? imageUrl : '',
        "newsType": selectedtype.value,
        "news_id": '',
        'created_date': now,
      }).then((DocumentReference documentReference) {
        // Get the generated document ID
        String documentId = documentReference.id;
        print("Generated document ID: $documentId");

        FirebaseFirestore.instance
            .collection('shortnews')
            .doc(documentId)
            .update({
          'news_id': documentId,
        }).then((_) {
          newsDescription.clear();
          referenceController.clear();
          referenceURLController.clear();
          titleController.clear();
          //selectedtype.value = 'Select News Type';
          // selectedValue.value = 'Select Language';
          fileName.value = '';
          imageBytes.value = null;

          sendNotification(titleController.text, "notification", imageUrl);

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

  Future<void> sendNotification(subject, title, image) async {
    print("kjdhgfhj ${image}");
    var uri = Uri.parse('https://fcm.googleapis.com/fcm/send');

    String toParams = "/topics/" + 'shotnews';

    final data = {
      "notification": {"body": subject, "image": image, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
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
