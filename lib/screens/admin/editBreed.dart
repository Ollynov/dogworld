import 'dart:convert';

import 'package:doggies/services/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './../../services/services.dart';
import './../../shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class EditBreedScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();

  @override
  Widget build(BuildContext context) {
    
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {

      return Scaffold (
          appBar: AppBar(title: Text('Admin'),),
          body: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Breed to Edit'),
              BreedListDropDown(),
              EditAndSaveRow(),

            ],
          )),
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
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                  children: [
                  DataRow(text: 'Name:', data: value.data.fullName),
                  DataRow(text: 'Description:', data: value.data.description),
                  DataRow(text: 'Life Span:', data: value.data.lifeSpan),
                  DataRow(text: 'Bred For:', data: value.data.bredFor),
                  DataRow(text: 'Group:', data: value.data.breedGroup),
                  DataRow(text: 'Height (inch):', data: value.data.height),
                  DataRow(text: 'Weight (lb):', data: value.data.weight),
                  DataRow(text: 'Origin:', data: value.data.weight),
                ],),
          );
        } else {
          return Loader();
        }
      }
    );
  }
}

class DataRow extends StatelessWidget {
  final String text;
  final String data;
  const DataRow({Key key, this.text, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Row(children: [
          Text("$text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Roboto')),
          Flexible(child: Text(" $data", style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),))
      ]),
    );
  }
}

class EditAndSaveRow extends StatelessWidget {
  // final String text;
  // final String data;
  // const EditAndSaveRow({Key key, this.text, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        RaisedButton.icon(
          onPressed: ()=> {
            print('pressy pressy')

          }, 
          padding: EdgeInsets.all(16),
          icon: Icon(FontAwesomeIcons.edit), 
          label: Text('Edit', style: TextStyle(fontSize: 22),)
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RaisedButton.icon(
            onPressed: ()=> {
              print('pressy pressy')

            }, 
            padding: EdgeInsets.all(16),
            icon: Icon(FontAwesomeIcons.save), 
            label: Text('Save', style: TextStyle(fontSize: 22),)
          ),
        )
      ]),
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
    return null;
  }
}

