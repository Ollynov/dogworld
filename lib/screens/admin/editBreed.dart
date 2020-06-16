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

             if (snapshot.data != null) {
              List<Breed> allBreeds = snapshot.data;
          
              return Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(height: 2, color: Colors.black,),
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
                  ),
              );
             } else {
               return Loader();
             }
           }
        ),
        BreedDetails(breedId: dropdownValue)
      ],
    );
  }
}

class BreedDetails extends StatefulWidget {
  final String breedId;
  const BreedDetails({Key key, this.breedId}) : super(key: key);

  @override
  _BreedDetailsState createState() => _BreedDetailsState();
}

class _BreedDetailsState extends State<BreedDetails> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _lifeSpanController;
  TextEditingController _bredForController;
  TextEditingController _groupController;
  TextEditingController _heightController;
  TextEditingController _weightController;
  TextEditingController _originController;

  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _lifeSpanController = TextEditingController();
    _bredForController = TextEditingController();
    _groupController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _originController = TextEditingController();
  }

  void dispose() {
    _nameController.dispose(); _descriptionController.dispose(); _lifeSpanController.dispose(); _bredForController.dispose(); _groupController.dispose(); _heightController.dispose(); _weightController.dispose(); _originController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: fetchBreed(widget.breedId),
      builder: (BuildContext context, AsyncSnapshot<Breed> value) {
      // builder: (BuildContext context, AsyncSnapshot<TempModel> value) {

        if (value.data != null) {
          _nameController.text = value.data.fullName;
          _descriptionController.text = value.data.description;
          _lifeSpanController.text = value.data.lifeSpan;
          _bredForController.text = value.data.bredFor;
          _groupController.text = value.data.breedGroup;
          _heightController.text = value.data.height;
          _weightController.text = value.data.weight;
          _originController.text = value.data.origin;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                  children: [
                    Row(children: [
                      TitleColumn(text: 'Name'),
                      Flexible(child: 
                        TextField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),)
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Description'),
                      Flexible(child: 
                        TextField(
                          controller: _descriptionController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Life Span'),
                      Flexible(child: 
                        TextField(
                          controller: _lifeSpanController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),)
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Bred For'),
                      Flexible(child: 
                        TextField(
                          controller: _bredForController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Group'),
                      Flexible(child: 
                        TextField(
                          controller: _groupController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),)
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Height'),
                      Flexible(child: 
                        TextField(
                          controller: _heightController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Weight'),
                      Flexible(child: 
                        TextField(
                          controller: _weightController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),)
                      ),
                    ],),
                    Row(children: [
                      TitleColumn(text: 'Origin'),
                      Flexible(child: 
                        TextField(
                          controller: _originController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],),
                  EditAndSaveRow(fullName: _nameController, description: _descriptionController,),

                ],),
          );
        } else {
          return Loader();
        }
      }
    );
  }
}


class TitleColumn extends StatelessWidget {
  final String text;

  TitleColumn({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _controller.text = widget.data;

    return 
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: 130,
          child: 
            Text("$text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Roboto')),
        ),
      );
  }
}

class EditAndSaveRow extends StatelessWidget {
  final TextEditingController fullName;
  final TextEditingController description;
  final TextEditingController lifespan;
  final TextEditingController bredFor;
  final TextEditingController breedGroup;
  final TextEditingController height;
  final TextEditingController weight;
  final TextEditingController origin;

  const EditAndSaveRow({Key key, this.fullName, this.description, this.lifespan, this.bredFor, this.breedGroup, this.height, this.weight, this.origin}) : super(key: key);

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
            label: Text('Edit', style: TextStyle(fontSize: 22),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RaisedButton.icon(
              onPressed: ()=> {
                print('pressy pressy'),
                saveBreed(fullName: fullName.text, description: description.text, lifeSpan: lifespan.text, bredFor: bredFor.text, breedGroup: breedGroup.text, height: height.text, weight: weight.text, origin: origin.text)
              }, 
              padding: EdgeInsets.all(16),
              icon: Icon(FontAwesomeIcons.save), 
              label: Text('Save', style: TextStyle(fontSize: 22),),
            ),
          )
      ]),
    );
  }
}

Future<Breed> saveBreed({String description, String fullName, String lifeSpan, String bredFor, String breedGroup, String height, String weight, String origin}) async {
  print(description);
  print(fullName);
  print(lifeSpan);
  print(bredFor);
  print(breedGroup);
  print(height);
  print(weight);
  print(origin);

  // final response = await http.get('https://api.thedogapi.com/v1/breeds/search?q=$breedId');

  // if (true) {
    
  //   return 'chii';
  // } else {
    
  //   print('Failed to load album');
  //   return null;
  // }
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

