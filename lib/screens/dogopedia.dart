import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'breed.dart';


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
              title: Text('Breeds'),
              actions: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.home,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/'),
                ),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.userCircle,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                )
              ],
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
            bottomNavigationBar: AppBottomNav(route: 0, inactive: false,),
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
               Navigator.pushNamed(context, '/breed/${breed.id}', arguments: {'breedId': breed.id});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 330,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Image.asset(
                      'assets/covers/${breed.img}',
                      fit: BoxFit.contain,
                      // fit: BoxFit.,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          breed.fullName,
                          style: TextStyle(
                              height: 1.5, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ),
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


