import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/screens/admin/db.dart';
import 'package:doggies/services/users.dart';
import 'package:doggies/shared/admin/dogTimeTable.dart';
import 'package:doggies/shared/admin/dogWorldTable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './../../services/services.dart';
import './../../shared/shared.dart';
import 'package:provider/provider.dart';


class EditBreedScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();

  @override
  Widget build(BuildContext context) {
    
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {

      return Scaffold (
          appBar: AppBar(
            title: Text('Admin'),
            leading: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () { Navigator.pushNamed(context, '/');},
              tooltip: "Go Home",
            )
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select Breed to Edit'),
                BreedListDropDown(),
                // This should probably be refactored, but essentialy our breed list dropdown is what populates the rest of this screen since it is a future builder that waits for a dog value to be selected.
              ],
            )),
          ),
          bottomNavigationBar: AppBottomNav(route: 2, inactive: false,),
        );
    } else {
      return LoadingScreen();
    }
  }
}


class BreedListDropDown extends StatefulWidget {
  BreedListDropDown({Key key}) : super(key: key);

  @override
  _BreedListDropDownState createState() => _BreedListDropDownState();
}

class _BreedListDropDownState extends State<BreedListDropDown> {
  String dropdownValue = 'Affenpinscher';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
           future: Firestore.instance.collection("allBreeds").document('allBreeds').get(),
           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) { 

             if (snapshot.hasData) {
              List<dynamic> allBreeds = snapshot.data["allBreeds"];
          
              return Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(height: 2, color: Colors.black,),
                    onChanged: (String newValue) {setState(() {dropdownValue = newValue;});},
                    items: allBreeds.map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
              );
             } else {
               return Loader();
             }
           }
        ),
        BreedDetails(breedId: dropdownValue, dataSource: "Dog World"),
        BreedDetails(breedId: dropdownValue, dataSource: "Dog CEO",),
        DogTimeDetails(breedId: dropdownValue)
      ],
    );
  }
}



class EditAndSaveRow extends StatelessWidget {
  final String source;
  final String breedId;
  final TextEditingController fullName;
  final TextEditingController description;
  final TextEditingController lifeSpan;
  final TextEditingController bredFor;
  final TextEditingController breedGroup;
  final TextEditingController height;
  final TextEditingController weight;
  final TextEditingController origin;
  final TextEditingController img;
  final TextEditingController additionalImages;

  const EditAndSaveRow({Key key, this.breedId, this.fullName, this.description, this.lifeSpan, this.bredFor, this.breedGroup, this.height, this.weight, this.origin, this.img, this.additionalImages, this.source}) : super(key: key);


  @override
    Widget build(BuildContext context) {

      _showDialog() {
        // flutter defined function
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning!"),
              content: new Text("This will overwrite everything we have in our DB, are you sure?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Accept"),
                  onPressed: () {
                    saveBreed(breedId: breedId, fullName: fullName.text, description: description.text, lifeSpan: lifeSpan.text, bredFor: bredFor.text, breedGroup: breedGroup.text, height: height.text, weight: weight.text, origin: origin.text, img: img.text, additionalImages: additionalImages.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RaisedButton.icon(
              onPressed: (source == "Dog CEO") ? 
                () => _showDialog()
              : () => {
                saveBreed(breedId: breedId, fullName: fullName.text, description: description.text, lifeSpan: lifeSpan.text, bredFor: bredFor.text, breedGroup: breedGroup.text, height: height.text, weight: weight.text, origin: origin.text, img: img.text, additionalImages: additionalImages.text)
                // .then((value) => print(value))
              }, 
              padding: EdgeInsets.all(16),
              icon: Icon(FontAwesomeIcons.save), 
              label: (source == "Dog CEO") ?
                  Text('Overwrite Database', style: TextStyle(fontSize: 22)) :
                  Text('Save', style: TextStyle(fontSize: 22))
            ),
          )
      ]),
    );
  }
}

