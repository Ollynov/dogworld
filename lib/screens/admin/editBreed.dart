import 'dart:convert';

import 'package:doggies/services/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../../services/services.dart';
import './../../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SelectedBreed {
 String breedId = 'Affenpinscher';
}

var stream = Stream.fromIterable([SelectedBreed()]);


class EditBreedScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();

  @override
  Widget build(BuildContext context) {
    
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    // UserDetails userDetails = Provider.of<UserDetails>(context);


    if (user != null) {

      return StreamProvider<SelectedBreed>.value(
        value: stream,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Admin'),
          ),
          body: Center(
            child: SizedBox(
              width: 500,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text('Select Breed to Edit'),
                BreedListDropDown(),
            ],
          ),
              )),
          bottomNavigationBar: AppBottomNav(route: 2, inactive: false,),
        ),
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
           future: Collection<Breed>(path: 'allBreeds').getData(),
           builder: (BuildContext context, AsyncSnapshot<List<Breed>> snapshot) { 
             List<Breed> allBreeds = snapshot.data;
          
             return DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });

                },
                items: allBreeds.map<DropdownMenuItem<String>>((Breed value) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Text(value.id),
                  );
                }).toList(),
              );
           }
        ),
        BreedDetails(breedId: dropdownValue)
      ],
    );
  }
}

class BreedDetails extends StatelessWidget {
  final String breedId;
  const BreedDetails({Key key, this.breedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: fetchBreed(breedId),
      builder: (BuildContext context, AsyncSnapshot<Breed> value) {
      // builder: (BuildContext context, AsyncSnapshot<TempModel> value) {

        if (value.data != null) {
          return Column(children: [
            Text("here is data back: ${value.data.fullName}"),
            Text("here is data back: ${value.data.description}"),
            Text("here is data back: ${value.data.lifeSpan}"),
            Text("here is data back: ${value.data.bredFor}"),
            Text("here is data back: ${value.data.breedGroup}"),
            Text("here is data back: ${value.data.height}"),
            Text("here is data back: ${value.data.weight}"),
            Text("here is data back: ${value.data.origin}"),
          ],);
        } else {
          return Loader();
        }



      }
      
    );
  }
}

class TempModel {
  final String name;
  final int id;
  final String temperament;

  TempModel({this.name, this.id, this.temperament});

  factory TempModel.fromJson(Map<String, dynamic> json) {
    return TempModel(
      name: json['name'] ?? "",
      id: json['id'] ?? 0,
      temperament: json['temperament'] ?? "",
    );
  }
}


Future<Breed> fetchBreed(String breedId) async {
// Future<TempModel> fetchBreed(String breedId) async {
  final response = await http.get('https://api.thedogapi.com/v1/breeds/search?q=$breedId');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var decoded = json.decode(response.body);
    print('here is decoded: ');
    print(decoded);
    if (decoded.length > 0) {
      return Breed.fromJsonDogAPI(decoded[0]);
      // return TempModel.fromJson(decoded[0]);
    } else {
      return null;
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('Failed to load album');
  }
}

