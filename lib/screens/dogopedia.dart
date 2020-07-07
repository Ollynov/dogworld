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
  // List pagesOfData; We may want to save this in the future to serve as a cache to not perform a new search each time.
  List<String> previousBreeds = [];
  bool loading; 
  int perPageLimit = 4;
  String lastBreedId;

  _getMoreBreeds(allBreeds) {
    String last = allBreeds[allBreeds.length - 1].id;
    setState(() {
      lastBreedId = last;
    });
    previousBreeds.add(last);
  }
  _getPreviousBreeds() {
    var previousBreedId; 
    previousBreeds.length > 1 ? previousBreedId = previousBreeds[previousBreeds.length - 2] : previousBreedId = null;
    setState(() {
      lastBreedId = previousBreedId;
      previousBreeds.removeLast();
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   perPageLimit = 10;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global.breedsRef.getData(perPageLimit, lastBreedId),
      builder: (BuildContext context, AsyncSnapshot snap) {

        if (snap.hasData) {
          List<Breed> breeds = snap.data;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () { Navigator.pushNamed(context, '/');},
                tooltip: "Go Home",
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("The Dogopedia", style: Theme.of(context).textTheme.headline1),
                  ),
                  IconButton(
                    icon: Icon(Icons.search), 
                    onPressed: () {
                      print('pressy pressy');
                    }),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (previousBreeds.length > 0)
                        Tooltip(
                          message: "Previous dogs",
                          child: FlatButton(
                            onPressed: () => _getPreviousBreeds(),
                            child: Icon(FontAwesomeIcons.arrowLeft),
                            color: Colors.transparent,
                            padding: EdgeInsets.only(top: 40, bottom: 40),
                          ),
                        )
                      else 
                        Container(height: 50,),
                      
                      // if we have less than the perPageLimit displayed it means that we are on the last page and don't want to display the next button
                      if (breeds.length == perPageLimit)
                        Tooltip(
                          message: "View more dogs",
                          child: FlatButton(
                            onPressed: () => _getMoreBreeds(breeds),
                            child: Icon(FontAwesomeIcons.arrowRight),
                            color: Colors.transparent,
                            padding: EdgeInsets.only(top: 40, bottom: 40),
                          ),
                        )
                      else 
                        Container(height: 50,)
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

class BreedSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
      // TODO: implement buildActions
      throw UnimplementedError();
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // TODO: implement buildLeading
      throw UnimplementedError();
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // TODO: implement buildResults
      throw UnimplementedError();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
  
}
