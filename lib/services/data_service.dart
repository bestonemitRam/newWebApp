import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsweb/model/dashboard_model.dart';

class DataService {
  DocumentSnapshot? _lastDocument;
  List<DashBoardModel> data = [];
  Future<List<DashBoardModel>> fetchData() async {
    data.clear();
    try {
      CollectionReference myCollection =
          FirebaseFirestore.instance.collection('shortnews');
      QuerySnapshot snapshot = await myCollection
          .orderBy('created_date', descending: false)
          .limit(15)
          .get();
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;

        data = snapshot.docs
            .map((doc) => DashBoardModel(
                id: doc.id,
                description: doc['description'],
                img: doc['img'],
                news_id: doc['news_id'],
                news_link: doc['news_link'],
                title: doc['title'],
                video: doc['video'],
                from: doc['from'],
                takenby: doc['takenby'],
                created_date: doc['created_date'].toDate().toString()))
            .toList();
      }

      return data;
    } catch (e) {
      throw e;
    }
  }
}
