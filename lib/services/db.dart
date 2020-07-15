import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './globals.dart';

class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  DocumentReference ref;

  Document({this.path}) {
    ref = _db.document(path);
  }

  // Instead of writing one functon like this for every single type of "get" from our database, we can implement a generic getter, so that we do not need to do the "fromMap" function each time.
  // Future<Quiz> getQuiz(quizId) {
  //   return _db
  //       .collection('quizzes')
  //       .document(quizId)
  //       .get()
  //       .then((snap) => Quiz.fromMap(snap.data));
  // }

// This is our money function. <T> can be any of the data models we have defined inside of our Global.models class. The reason we need to do this is because Dart is strongly types, so we can't just run the .fromMap function onto any generic type.
  Future<T> getData() {
    try {
      print('at least trying');
      var result = ref.get().then((v) => Global.models[T](v.data) as T);
      return result;
    } catch(err) {
      print('got error: ');
      print(err);
      throw "ok got error!!";
    }
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }

  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
    // return ref.setData(Map<String, dynamic>.from(data), merge: true);
    
  }
}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Collection({this.path}) {

    ref = _db.collection(path);
    
  }

  Future<List<T>> getData(limit, startAfter) async {
    try {
      QuerySnapshot snapshots;
      if (limit != null && startAfter != null) {
        snapshots = await ref.orderBy("id").startAfter([startAfter]).limit(limit).getDocuments();
      } else if (limit != null) {
        snapshots = await ref.limit(limit).getDocuments();
      } else {
        snapshots = await ref.getDocuments();
      }

      return snapshots.documents
          .map<T>((doc) => Global.models[T](doc.data) as T)
          .toList();
    } catch (err) {
      print('ok here is err: ');
      print(err);
      throw 'got error';
    }
  }

  Stream<List<T>> streamData() {
    return ref.snapshots().map(
        (list) => list.documents.map((doc) => Global.models[T](doc.data) as T));
  }
}

// Depending on what you pass in as the type, as well as the collection to the UserData class, you will get data back in a clean way for users across our entire app. One thing you can consider is making this a more broad class called "User" which can also set data, as well as many other things. But for now you should keep like this. You can always have another "SetData" class.

// The cool thing about UserData class is that it gets the user information based on whoever is logged in. And does not require you to pass in a user id as a parameter.
class UserData<T> {
  // final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({this.collection});

  Stream<T> get documentStream {
    // The function switchMap is an operator (method) that comes out of the box with rxdart. I need to look more into the switchMap function, but it allows us to switch from one stream to another. So once we get back the full 'user' object which we are looking for here, (when it is not null), it will switch to another stream.

    // The other nice thing about this functon is that it will automatically return "null" in the stream when you log out, and therefore you will unsubscribe.
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        Document<T> doc = Document<T>(path: '$collection/${user.uid}');
        return doc.streamData();    
      } else {
        return Stream<T>.value(null);
      }
    });
  }

  Future<T> getDocument() async {

    try {
      FirebaseUser user = await _auth.currentUser();
      if (user!= null) {
        Document doc = Document<T>(path: '$collection/${user.uid}');
        // This will return back a nice unserialized version of the user information.
        return doc.getData();
      } else {
        print('ok not logged in yet: ');
        throw 'not even logged in';
      }
    } catch(err) {
      print('ok getting error');
      print(err);
      throw "user is null";
    }

    // if (user != null) {
    //   Document doc = Document<T>(path: '$collection/${user.uid}');
    //   // This will return back a nice unserialized version of the user information.
    //   print('ok getting back user');
    //   return doc.getData();
    // } else {
    //   print('ok getting null for logged in user');
    //   return null;
    // }
  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Document<T> ref = Document(path: '$collection/${user.uid}');
    return ref.upsert(data);
  }
}
