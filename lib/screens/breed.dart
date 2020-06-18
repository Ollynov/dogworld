import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class BreedScreen extends StatelessWidget {
  final String breedId;
  final Breed breed;
  BreedScreen({this.breedId, this.breed});

  
  @override
  Widget build(BuildContext context) {
    print('will run with breedId: ');
    print(breedId);

    final dynamic args = ModalRoute.of(context).settings.arguments;
    print('here are args:');
    print(args);
    
    return FutureBuilder(
      future: Document<Breed>(path: 'Breed/$breedId').getData(),
      builder: (BuildContext context, AsyncSnapshot<Breed> snap) {

        if (snap.hasData) {

          Breed breed = snap.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('${breed.fullName}'),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(children: [
                Stack(
                  children: [
                    Hero(
                      tag: breed.img,
                      child: 
                        (breed.img.split("//")[0] == "https:"? 
                          Image.network(
                            breed.img, 
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                          ) :
                          Image.asset(
                            'assets/covers/${breed.img}',
                            width: MediaQuery.of(context).size.width,
                            height: 500,
                          )
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FavoriteButton(breedId: breed.id)
                      ],
                    ),
                  ],
                ),
                BreedDetails(breed: breed)
              ]),
            ),
          );

        } else {
          return LoadingScreen();
        }
      

      }
    );
  }
}

class FavoriteButton extends StatefulWidget {
  FavoriteButton({Key key, this.breedId}) : super(key: key);
  final String breedId;


  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorited = false;


  @override 
  Widget build(BuildContext context) {

    UserDetails userDetails = Provider.of<UserDetails>(context);


    if (userDetails != null && userDetails.favoriteBreeds.contains(widget.breedId)) {
      setState(() {
        isFavorited = true;
      });
    }    

    return FlatButton(
      onPressed: () async {
        if (userDetails.uid != "") {
          if (isFavorited == false) {
            // this means that we are now favoriting this breed for the first time, so lets add to DB
            _addNewBreedToFavorites(widget.breedId);
          } else {
            //remove from DB
            _removeBreedFromFavorites(widget.breedId);
          }
          setState(() {
            isFavorited = !isFavorited;
          });
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: GestureDetector(
              child: Text("You must be logged in to save a favorite dog breed."),
              onTap: () {Navigator.pushNamed(context, '/login');},
            ),
            
            backgroundColor: Theme.of(context).primaryColorLight,
          ));
        }

      }, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          (isFavorited? 
            FaIcon(FontAwesomeIcons.solidHeart, color: Theme.of(context).primaryColor):
            FaIcon(FontAwesomeIcons.heart, color: Theme.of(context).primaryColor)),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('Favorite', style: TextStyle(fontSize: 20.0),),
          ),
        ],
      ),
      color: Theme.of(context).cardTheme.color,
      );
  }
}

class BreedDetails extends StatelessWidget {
  final Breed breed;
  BreedDetails({Key key, this.breed});

  @override
  Widget build(BuildContext context) {
    print(breed.fullName);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Card(
            child: Container(
              child: Text(
                breed.description,
                style: TextStyle(height: 2, fontSize: 20),
              ),
            ),
          ),
        ),
        Container(
          height: 320,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[

              ListItem(title: "Life Span", data: breed.lifeSpan),
              ListItem(title: "Bred For", data: breed.bredFor),
              ListItem(title: "Group", data: breed.breedGroup),
              ListItem(title: "Height", data: breed.height),
              ListItem(title: "Weight", data: breed.weight),
              ListItem(title: "Origin", data: breed.origin)
            ],
          ),
        )
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String data;
  ListItem({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
            child: ListTile(
              leading: FlutterLogo(size: 56.0),
              title: Text(title, style: TextStyle(fontSize: 30)),
              subtitle: Text('$data', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.more_vert),
            ),
           );
  }
}

Future<void> _addNewBreedToFavorites(String breedId) {
  return Global.userDetailsRef.upsert(
    ({
      'favoriteBreeds': FieldValue.arrayUnion([breedId])
    }),
  );
}
Future<void> _removeBreedFromFavorites(String breedId) {
  return Global.userDetailsRef.upsert(
    ({
      'favoriteBreeds': FieldValue.arrayRemove([breedId])
    }),
  );
}
