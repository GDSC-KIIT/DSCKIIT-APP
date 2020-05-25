import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsckiit_app/model/meeting.dart';

final CollectionReference meetingCollection =
    Firestore.instance.collection('meetings');

class FirebaseFirestoreService {
  static final FirebaseFirestoreService _instance =
      new FirebaseFirestoreService.internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

  Future<Meeting> createMeeting(String title, String date, String time, String link) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(meetingCollection.document());

      final Meeting meeting = new Meeting(title, link, date, time);
      final Map<String, dynamic> data = meeting.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Meeting.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
}