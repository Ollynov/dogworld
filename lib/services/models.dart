// These functions in this file essentially allow us to deserialize data that we get back from firebase. Firebase sends us back data in the form of a map. It is possible to use that map directly to achieve what you need to but this gives us consistency, and also gives us a central area to define data.
class Report {
  String uid;
  int total;
  Map topics;

  // first constructor method applying those properties we have defined above.
  Report({this.uid, this.topics, this.total});

  // so this parameter 'data' that we pass to our Report is the data that we get back from firestore. This factory fromMap function can be seen as a secondary constructor method.
  factory Report.fromMap(Map data) {
    return Report(
        uid: data['uid'] ?? "",
        topics: data['topics'] ?? 0,
        total: data['total'] ?? {});
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

  Question.fromMap(Map data) {
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

  factory Quiz.fromMap(Map data) {
    return Quiz(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        topic: data['topic'] ?? '',
        description: data['description'] ?? '',
        video: data['video'] ?? '',
        questions: (data['questions'] as List ?? [])
            .map((v) => Question.fromMap(v))
            .toList());
  }
}

class Breed {
  // final String id;
  final String fullName;
  final String description;
  final String img;
  final List<String> variations;
  // final List<Quiz> quizzes;

  Breed({this.fullName, this.description, this.img, this.variations});
  // Topic({this.id, this.title, this.description, this.img, this.quizzes});

  factory Breed.fromMap(Map data) {
    return Breed(
        fullName: data['fullName'] ?? '',
        description: data['description'] ?? '',
        img: data['img'] ?? 'default.png',
        variations: (data['variations'] as List ?? [])
        // .map((v) => Quiz.fromMap(v))
        // .toList(),
        // quizzes: (data['quizzes'] as List ?? [])
        //     .map((v) => Quiz.fromMap(v))
        //     .toList(), //data['quizzes'],
        );
  }
}
