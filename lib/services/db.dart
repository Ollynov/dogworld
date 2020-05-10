import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future<Map> getQuiz(quizId) {
    return _db
        .collection('quizzes')
        .document(quizId)
        .get()
        .then((snap) => snap.data);
  }
}

loadData() async {
  var data = await DatabaseService().getQuiz('poi');

  var formattedData = Text(data['description'] ?? 'backup string');
  return formattedData;
}
