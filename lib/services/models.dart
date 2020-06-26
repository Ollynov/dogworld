// These functions in this file essentially allow us to deserialize data that we get back from firebase. Firebase sends us back data in the form of a map. It is possible to use that map directly to achieve what you need to but this gives us consistency, and also gives us a central area to define data.
import 'package:doggies/services/services.dart';

class Report {
  String uid;
  int total;
  Map topics;
  bool quizComplete;
  int totalQuizQuestions;
  int completedQuizQuestions;

  // first constructor method applying those properties we have defined above.
  Report(
      {this.uid,
      this.topics,
      this.total,
      this.quizComplete,
      this.totalQuizQuestions,
      this.completedQuizQuestions});

  // so this parameter 'data' that we pass to our Report is the data that we get back from firestore. This factory fromMap function can be seen as a secondary constructor method.
  factory Report.convertFromFireBaseMap(Map data) {
    return Report(
        uid: data['uid'] ?? "",
        topics: data['topics'] ?? 0,
        total: data['total'] ?? {},
        quizComplete: data['quizComplete'] ?? false,
        totalQuizQuestions: data['totalQuizQuestions'] ?? 0,
        completedQuizQuestions: data['completedQuizQuestions'] ?? 0);
  }
}

class UserDetails {
  String uid;
  String displayName;
  List<dynamic> favoriteBreeds;
  String lastActivity;


  // first constructor method applying those properties we have defined above.
  UserDetails({this.uid,
      this.displayName,
      this.favoriteBreeds,
      this.lastActivity});

  // so this parameter 'data' that we pass to our UserDetails is the data that we get back from firestore in the Map format. This factory fromMap function can be seen as a secondary constructor method. This will do 2 primary things: it will return our return value as an instance of UserDetails (instead of a Map), and it will also be sure to give us some default values in case we have none. 
  factory UserDetails.convertFromFireBaseMap(Map data) {
    return UserDetails(
        uid: data['uid'] ?? "",
        displayName: data['displayName'] ?? "",
        favoriteBreeds: data['favoriteBreeds'] ?? [],
        lastActivity: data['quizComplete'] ?? "");
  }
}

class Option {
  String value;
  String detail;
  bool correct;

  Option({this.correct, this.value, this.detail});
  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}

class Question {
  String text;
  List<Option> options;
  Question({this.options, this.text});

  Question.convertFromFireBaseMap(Map data) {
    text = data['text'] ?? '';
    options =
        (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
  }
}

///// Database Collections

class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {this.title,
      this.questions,
      this.video,
      this.description,
      this.id,
      this.topic});

  factory Quiz.convertFromFireBaseMap(Map data) {
    return Quiz(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        topic: data['topic'] ?? '',
        description: data['description'] ?? '',
        video: data['video'] ?? '',
        questions: (data['questions'] as List ?? [])
            .map((v) => Question.convertFromFireBaseMap(v))
            .toList());
  }
}

class Breed {
  final String id;
  final String fullName;
  final String description;
  String img;
  final String lifeSpan;
  final String bredFor;
  final String breedGroup;
  final String height;
  final String weight;
  final String origin;
  final int dogApiId;
  
  Breed({this.fullName, this.description, this.img, this.id, this.lifeSpan, this.bredFor, this.breedGroup, this.height, this.weight, this.origin, this.dogApiId});

  factory Breed.convertFromFireBaseMap(Map data) {
    if (data == null) { 
      return null;
    }
    return Breed(
      id: data['id'] ?? "",
      fullName: data['fullName'] ?? '',
      description: data['description'] ?? '',
      img: data['img'] ?? 'default.png',
      lifeSpan: data['lifeSpan'] ?? '',
      bredFor: data['bredFor'] ?? '',
      breedGroup: data['breedGroup'] ?? '',
      height: data['height'] ?? "",
      weight: data['weight'] ?? '',
      origin: data['origin'] ?? '',

      // variations: (data['variations'] as List<String> ?? [])
      // quizzes: (data['quizzes'] as List ?? [])
      //     .map((v) => Quiz.fromMap(v))
      //     .toList(), //data['quizzes'],
    );
  }

  factory Breed.fromJsonDogAPI(Map<String, dynamic> json) {
    return Breed(
      fullName: json['name'] ?? "",
      description: json['temperament'] ?? "",
      lifeSpan: json['life_span'] ?? "",
      bredFor: json['bred_for'] ?? "",
      breedGroup: json['breed_group'] ?? "",
      height: json['height']['imperial'] ?? "",
      weight: json['weight']['imperial'] ?? "",
      origin: json['origin'] ?? "",
      dogApiId: json['id'] ?? null,
      img: ""
    );
  }
  factory Breed.fromJsonDogAPIJustImage(Map<String, dynamic> json) {
    return Breed(
      img: json['url'] ?? "www.example.com",
      
    );
  }

  // get id => null;
}
