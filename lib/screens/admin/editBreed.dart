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

    // var selectedBreed = Provider.of<SelectedBreed>(context);

    return Container(
      child: Text('Here is selected: $breedId'),
    );
  }

}
