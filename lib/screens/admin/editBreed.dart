import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/services/users.dart';
import 'package:doggies/shared/admin/dogTimeTable.dart';
import 'package:doggies/shared/admin/dogWorldTable.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String dropdownValue = 'Bernese Mountain Dog';

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
