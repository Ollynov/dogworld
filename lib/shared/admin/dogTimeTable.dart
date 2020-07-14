import 'package:doggies/screens/admin/db.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/shared/admin/infoRow.dart';
import 'package:doggies/shared/loader.dart';
import 'package:flutter/material.dart';


class DogTimeDetails extends StatefulWidget {
  final String breedId;

  DogTimeDetails({Key key, this.breedId}) : super(key: key);

  @override
  _DogTimeDetailsState createState() => _DogTimeDetailsState();
}

class _DogTimeDetailsState extends State<DogTimeDetails> {
  TextEditingController _adaptsToApartmentController = TextEditingController();
  TextEditingController _forNoviceController = TextEditingController();
  TextEditingController _sensitivityController = TextEditingController();
  TextEditingController _beingAloneController = TextEditingController();
  TextEditingController _coldWeatherController = TextEditingController();
  TextEditingController _hotWeatherController = TextEditingController();
  TextEditingController _familyFriendlyController = TextEditingController();
  TextEditingController _kidFriendlyController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // _controller.text = widget.data;

    return FutureBuilder(
      future: fetchBreedFromDogtime(widget.breedId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> value) {
        
        if (value != null && value.data != null) {
          DogtimeDog dog = value.data;

          _adaptsToApartmentController.text = dog.adaptsToApartment;
          _forNoviceController.text = dog.forNovice;
          _sensitivityController.text = dog.sensitivity;
          _beingAloneController.text = dog.beingAlone;
          _coldWeatherController.text = dog.coldWeather;
          _hotWeatherController.text = dog.hotWeather;
          _familyFriendlyController.text = dog.familyFriendly;
          _kidFriendlyController.text = dog.kidFriendly;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Dogtime", style: Theme.of(context).textTheme.headline2)
                  ],
                ),
                InfoRow(text: "Adapts Well To Apartment Living", controller: _adaptsToApartmentController),
                InfoRow(text: "Good For Novice Owners", controller: _forNoviceController),
                InfoRow(text: "Sensitivity Level", controller: _sensitivityController),
                InfoRow(text: "Tolerates Being Alone", controller: _beingAloneController),
                InfoRow(text: "Tolerates Cold Weather", controller: _coldWeatherController),
                InfoRow(text: "Tolerates Hot Weather", controller: _hotWeatherController),
                InfoRow(text: "Affectionate With Family", controller: _familyFriendlyController),
                InfoRow(text: "Kid-Friendly", controller: _kidFriendlyController),
              ]
            )
          );
        } else {
          return Loader();
        }

      }
    );
  }
}
