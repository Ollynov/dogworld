import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DogopediaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global.breedsRef.getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Breed> breeds = snap.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text('Breeds'),
              // actions: [
              //   IconButton(
              //     icon: Icon(FontAwesomeIcons.userCircle,
              //         color: Colors.pink[200]),
              //     onPressed: () => Navigator.pushNamed(context, '/profile'),
              //   )
              // ],
            ),
            // drawer: TopicDrawer(topics: snap.data),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children:
                  breeds.map((breed) => BreedPreview(breed: breed)).toList(),
            ),
            bottomNavigationBar: AppBottomNav(),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class BreedPreview extends StatelessWidget {
  final Breed breed;
  const BreedPreview({Key key, this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: breed.img,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => TopicScreen(breed: breed),
              //   ),
              // );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/covers/${breed.img}',
                  fit: BoxFit.contain,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          breed.fullName,
                          style: TextStyle(
                              height: 1.5, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ),
                    Text(breed.description)
                  ],
                ),
                // )
                // TopicProgress(topic: topic),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BreedScreen extends StatelessWidget {
  final Breed breed;

  BreedScreen({this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: breed.img,
          child: Image.asset('assets/covers/${breed.img}',
              width: MediaQuery.of(context).size.width),
        ),
        Text(
          breed.fullName,
          style:
              TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // QuizList(breed: breed)
      ]),
    );
  }
}

// class QuizList extends StatelessWidget {
//   final Breed breed;
//   QuizList({Key key, this.topic});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         children: breed.quizzes.map((quiz) {
//       return Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         elevation: 4,
//         margin: EdgeInsets.all(4),
//         child: InkWell(
//           // onTap: () {
//           //   Navigator.of(context).push(
//           //     MaterialPageRoute(
//           //       builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
//           //     ),
//           //   );
//           // },
//           child: Container(
//             padding: EdgeInsets.all(8),
//             child: ListTile(
//               title: Text(
//                 quiz.title,
//                 style: Theme.of(context).textTheme.title,
//               ),
//               subtitle: Text(
//                 quiz.description,
//                 overflow: TextOverflow.fade,
//                 style: Theme.of(context).textTheme.subhead,
//               ),
//               // leading: QuizBadge(topic: topic, quizId: quiz.id),
//             ),
//           ),
//         ),
//       );
//     }).toList());
//   }
// }
