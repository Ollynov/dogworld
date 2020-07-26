
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/carousel.dart';
import 'package:doggies/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class BreedScreen extends StatelessWidget {
  String breedId;
  final Breed breed;
  BreedScreen({this.breedId, this.breed});

  
  @override
  Widget build(BuildContext context) {
    breedId = Uri.decodeFull(breedId);

    // the args here is if we want to use data that we pass from the dogopedia screen. The big benefit here is one less API call, and simply pass in the data we already have. The downside is that if someone visits the page directly they will have no data. The best approach is a combo of both. 
    // final dynamic args = ModalRoute.of(context).settings.arguments;
    
    
    return FutureBuilder(
      future: Document<Breed>(path: 'Breed/$breedId').getData(),
      builder: (BuildContext context, AsyncSnapshot<Breed> snap) {

        if (snap.hasData) {

          Breed breed = snap.data;
          return Scaffold(
            appBar: AppBar(
              // leading: IconButton(
              //   icon: const Icon(Icons.home),
              //   onPressed: () { Navigator.pushNamed(context, '/');},
              //   tooltip: "Go Home",
              // )
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Stack(
                  children: [
                    // ConstrainedBox(
                    //   constraints: new BoxConstraints(maxHeight: 640),
                    Hero(
                      tag: breed.id,
                      child: Carousel(images: new List.from([breed.img])..addAll(breed.additionalImages))
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: FavoriteButton(breedId: breed.id),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${breed.fullName}', style: Theme.of(context).textTheme.headline2),
                ),
                BreedDetails(breed: breed),
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



class BreedDetails extends StatelessWidget {
  final Breed breed;
  BreedDetails({Key key, this.breed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  breed.description,
                  style: TextStyle(height: 2, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TabRow(breed: breed),
        ),
      ],
    );
  }
}

class TabRow extends StatefulWidget {
  final Breed breed;

  TabRow({this.breed});

  @override
  _TabRowState createState() => _TabRowState();
}

class _TabRowState extends State<TabRow> with TickerProviderStateMixin{
  TabController _tabController;


  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }


  @override 
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            height: 50,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*.12, right: MediaQuery.of(context).size.width*.12),
            child: 
            TabBar(
              tabs: [
                Container(height: 50, child: new Text('Vitals', style: TextStyle(fontSize: 20),),),
                Container(height: 50, child: new Text('Characteristics', style: TextStyle(fontSize: 20),),)
              ],
              unselectedLabelColor: const Color(0xffacb3bf),
              indicatorColor: Theme.of(context).accentColor,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0,
              indicatorPadding: EdgeInsets.all(20),
              isScrollable: false,
              controller: _tabController,
            ),
          ),
          Container(
            height: 600,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Vitals(breed: widget.breed,),
                Characteristics(breed: widget.breed,)
              ]),
          )
        ],
      );
  }
}

class Vitals extends StatelessWidget {
  Breed breed;

  Vitals({this.breed});

  @override 
  Widget build(BuildContext context) {
    return ListView(
      children: [
          ListItem(title: "Life Span", data: breed.lifeSpan, icon: FontAwesomeIcons.heart,),
          ListItem(title: "Bred For", data: breed.bredFor, icon: FontAwesomeIcons.baby,),
          ListItem(title: "Group", data: breed.breedGroup, icon: FontAwesomeIcons.layerGroup,),
          ListItem(title: "Height", data: "${breed.height} inches", icon: FontAwesomeIcons.textHeight),
          ListItem(title: "Weight", data: "${breed.weight} pounds", icon: FontAwesomeIcons.weightHanging),
          ListItem(title: "Origin", data: breed.origin, icon: FontAwesomeIcons.home,)
      ],
    );
  }
}

class Characteristics extends StatelessWidget {
  Breed breed;

  Characteristics({this.breed});

  @override 
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection("BreedCharacteristics1").document(breed.id).get(), 
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final ourCharacteristics = snapshot.data;
          print('here we go: ');
          print(ourCharacteristics["Dog Friendly"]);
          print(ourCharacteristics);
          return Loader();
        } else {
          return Loader();
        }
      });
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String data;
  final IconData icon;
  ListItem({this.title, this.data, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
            child: ListTile(
              leading: Icon(icon),
              title: Text(title, style: TextStyle(fontSize: 30)),
              subtitle: Text('$data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              // trailing: Icon(Icons.more_vert),
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

    return Opacity(
      opacity: .85,
      child: RaisedButton(
        padding: EdgeInsets.all(5),
        onPressed: () async {
          if (userDetails != null && userDetails.uid != "") {
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
          // mainAxisSize: MainAxisSize.min,
          children: [
            (isFavorited? 
              FaIcon(FontAwesomeIcons.solidHeart, color: Theme.of(context).primaryColor, size: 16,):
              FaIcon(FontAwesomeIcons.heart, color: Theme.of(context).primaryColor, size: 16,)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Favorite', style: TextStyle(fontSize: 14.0),),
            ),
          ],
        ),
        color: Theme.of(context).cardTheme.color,
        
        ),
    );
  }
}
