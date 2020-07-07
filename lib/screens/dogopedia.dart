import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';


class DogopediaScreen extends StatefulWidget {
  @override
  _DogopediaScreenState createState() => _DogopediaScreenState();
}

class _DogopediaScreenState extends State<DogopediaScreen> {
  List pagesOfData;
  bool loading; 
  int perPageLimit;
  Breed lastDocument;

  _getMoreBreeds() async {
    print('running');
    Query q = Firestore.instance.collection('Breed').startAfter([lastDocument]).limit(perPageLimit);
    QuerySnapshot querySnapshot = await q.getDocuments();
    print('ok query: ');
    print(querySnapshot);
    var newy = querySnapshot.documents[querySnapshot.documents.length - 1];

    print('here is what our last doc looks like: ');
    print(newy);
    print('here are our new dogies: ');
    print(querySnapshot.documents);
    pagesOfData.add(querySnapshot.documents);
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    perPageLimit = 10;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global.breedsRef.getData(perPageLimit),
      builder: (BuildContext context, AsyncSnapshot snap) {

        if (snap.hasData) {
          // setState(() {
          //   loading = false;
          //   lastDocument = snap.data[snap.data.length - 1];
          // });
           lastDocument = snap.data[snap.data.length - 1];
          List<Breed> breeds = snap.data;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () { Navigator.pushNamed(context, '/');},
                tooltip: "Go Home",
              ),
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       FontAwesomeIcons.userCircle,
              //     ),
              //     onPressed: () => Navigator.pushNamed(context, '/login'),
              //   )
              // ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("The Dogopedia", style: Theme.of(context).textTheme.headline1),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: ResponsiveGridRow(children: breeds.map((breed) => 
                      ResponsiveGridCol(
                        xs: 6,
                        md: 3,
                        child: Container(
                          // height: 300,
                          alignment: Alignment(0, 0),
                          child: BreedPreview(breed: breed),
                        ),
                      )
                    ).toList()),
                  ),
                  Row(
                    children: [
                      FlatButton(
                        onPressed: () => _getMoreBreeds(),
                        child: Icon(FontAwesomeIcons.arrowLeft),
                        color: Colors.transparent,
                        padding: EdgeInsets.only(top: 80, bottom: 80),
                      ),
                      FlatButton(
                        onPressed: () => _getMoreBreeds(),
                        child: Icon(FontAwesomeIcons.arrowRight),
                        color: Colors.transparent,
                        padding: EdgeInsets.only(top: 80, bottom: 80),
                      )
                    ],
                  )
                ],
              ),
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
    return Hero(
      tag: breed.id,
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
                height: 240,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: 
                    (breed.img.split("//")[0] == "https:"? 
                      Image.network(
                        breed.img, 
                        fit: BoxFit.contain,
                      ) :
                      Image.asset(
                        'assets/covers/${breed.img}',
                        fit: BoxFit.contain,
                      )
                    )
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
                        overflow: TextOverflow.ellipsis,
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
    );
  }
}


