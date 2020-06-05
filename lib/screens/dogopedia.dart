import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer' as developer;


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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BreedScreen(breed: breed),
                ),
              );
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

class BreedScreen extends StatefulWidget {
  final Breed breed;

  BreedScreen({this.breed});

  @override
  _BreedScreenState createState() => _BreedScreenState();
}

class _BreedScreenState extends State<BreedScreen> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.breed.fullName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListView(children: [
          Stack(
            children: [
              Hero(
                tag: widget.breed.img,
                child: Image.asset(
                  'assets/covers/${widget.breed.img}',
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: () async {
                      // here we need to save to our favorites
                      _addNewBreedToFavorites(widget.breed.id);
                     setState(() {
                       isFavorited = !isFavorited;
                     });
                    }, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (isFavorited? FaIcon(FontAwesomeIcons.solidHeart, color: Theme.of(context).primaryColor):
                        FaIcon(FontAwesomeIcons.heart, color: Theme.of(context).primaryColor)),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text('Favorite', style: TextStyle(fontSize: 20.0),),
                        ),
                      ],
                    ),
                    color: Theme.of(context).cardTheme.color,
                    ),
                ],
              ),
            ],
          ),
          BreedDetails(breed: widget.breed)
        ]),
      ),
    );
  }
}

class BreedDetails extends StatelessWidget {
  final Breed breed;
  BreedDetails({Key key, this.breed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        width: 300,
        child: Text(
          breed.description,
          style: TextStyle(height: 2, fontSize: 20),
        ),
      ),
    );
  }
}

Future<void> _addNewBreedToFavorites(breedId) {
  print('ok trying to add');
  print(breedId);
  return Global.userDetailsRef.upsert(
    ({
      'favoriteBreeds': FieldValue.arrayUnion(breedId),
    }),
  );
}
