import 'package:doggies/screens/admin/db.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:doggies/shared/admin/infoRow.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class DogTimeDetails extends StatefulWidget {
  final String breedId;
  final String source;
  DogtimeDog dog;

  DogTimeDetails({Key key, this.breedId, this.source}) : super(key: key);

  @override
  _DogTimeDetailsState createState() => _DogTimeDetailsState();

  // void didUpdateWidget(BreedListDropDown oldWidget) {
  //   // this method IS called when parent widget is rebuilt
  //   super.didUpdateWidget(oldWidget);
  // }
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
  TextEditingController _dogFriendlyController = TextEditingController();
  TextEditingController _strangerFriendlyController = TextEditingController();
  TextEditingController _sheddingController = TextEditingController();
  TextEditingController _droolingController = TextEditingController();
  TextEditingController _easyToGroomController = TextEditingController();
  TextEditingController _healthController = TextEditingController();
  TextEditingController _weightGainController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _trainingEaseController = TextEditingController();
  TextEditingController _iqController = TextEditingController();
  TextEditingController _mouthinessController = TextEditingController();
  TextEditingController _preyDriveController = TextEditingController();
  TextEditingController _barkingController = TextEditingController();
  TextEditingController _wanderlustController = TextEditingController();
  TextEditingController _energyController = TextEditingController();
  TextEditingController _intensityController = TextEditingController();
  TextEditingController _exerciseNeedController = TextEditingController();
  TextEditingController _playfulnessController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    clear();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          if (widget.source == "Dogtime")
            Row(
              children: [
                Text("Dogtime", style: Theme.of(context).textTheme.headline2)
              ],
            )
          else 
            Row(
              children: [
                Text("Dog World", style: Theme.of(context).textTheme.headline2)
              ],
            ),

          InfoRow2(text: "Adapts Well To Apartment Living", controller: _adaptsToApartmentController),
          InfoRow2(text: "Good For Novice Owners", controller: _forNoviceController),
          InfoRow2(text: "Sensitivity Level", controller: _sensitivityController),
          InfoRow2(text: "Tolerates Being Alone", controller: _beingAloneController),
          InfoRow2(text: "Tolerates Cold Weather", controller: _coldWeatherController),
          InfoRow2(text: "Tolerates Hot Weather", controller: _hotWeatherController),
          InfoRow2(text: "Affectionate With Family", controller: _familyFriendlyController),
          InfoRow2(text: "Kid-Friendly", controller: _kidFriendlyController),
          InfoRow2(text: "Dog Friendly", controller: _dogFriendlyController),
          InfoRow2(text: "Friendly Toward Strangers", controller: _strangerFriendlyController),
          InfoRow2(text: "Amount Of Shedding", controller: _sheddingController),
          InfoRow2(text: "Drooling Potential", controller: _droolingController),
          InfoRow2(text: "Easy To Groom", controller: _easyToGroomController),
          InfoRow2(text: "General Health", controller: _healthController),
          InfoRow2(text: "Potential For Weight Gain", controller: _weightGainController),
          InfoRow2(text: "Size", controller: _sizeController),
          InfoRow2(text: "Easy To Train", controller: _trainingEaseController),
          InfoRow2(text: "Intelligence", controller: _iqController),
          InfoRow2(text: "Potential For Mouthiness", controller: _mouthinessController),
          InfoRow2(text: "Prey Drive", controller: _preyDriveController),
          InfoRow2(text: "Tendency To Bark Or Howl", controller: _barkingController),
          InfoRow2(text: "Wanderlust Potential", controller: _wanderlustController),
          InfoRow2(text: "Energy Level", controller: _energyController),
          InfoRow2(text: "Intensity", controller: _intensityController),
          InfoRow2(text: "Potential For Playfulness", controller: _playfulnessController),
          InfoRow2(text: "Exercise Needs", controller: _exerciseNeedController),
          Row(
            children: [
              new FlatButton(
                child: new Text("Fill Table"),
                  onPressed: () async {
                    _fillTable();
                  },
                ),
              new FlatButton(
                child: new Text("Copy to our DB"),
                  onPressed: () {
                    // here we need to pass in the actual controller values and not the widget.dog so that it can get the latest changed values, but only for our own db, not dogtimeTable
                    _save();
                  },
                ),
            ],
          )
        ]
      ),
    );
  }






  Future<void> _fillTable() async {

    DogtimeDog dog;

    if (widget.source == "Dogtime") {
      widget.dog = await fetchBreedFromDogtime(widget.breedId, widget.source);
    } else {
      widget.dog = await Document<DogtimeDog>(path: 'BreedCharacteristics1/${widget.breedId}').getData();
    }
    if (widget.dog != null) {dog = widget.dog;}
    
    if (dog != null) {

      _adaptsToApartmentController.text = dog.adaptsToApartment;
      _forNoviceController.text = dog.forNovice;
      _sensitivityController.text = dog.sensitivity;
      _beingAloneController.text = dog.beingAlone;
      _coldWeatherController.text = dog.coldWeather;
      _hotWeatherController.text = dog.hotWeather;
      _familyFriendlyController.text = dog.familyFriendly;
      _kidFriendlyController.text = dog.kidFriendly;
      _dogFriendlyController.text = dog.dogFriendly;
      _strangerFriendlyController.text = dog.strangerFriendly;
      _sheddingController.text = dog.shedding;
      _droolingController.text = dog.drooling;
      _easyToGroomController.text = dog.easyToGroom;
      _healthController.text = dog.health;
      _weightGainController.text = dog.weightGain;
      _sizeController.text = dog.size;
      _trainingEaseController.text = dog.trainingEase;
      _iqController.text = dog.iq;
      _mouthinessController.text = dog.mouthiness;
      _preyDriveController.text = dog.preyDrive;
      _barkingController.text = dog.barking;
      _wanderlustController.text = dog.wanderlust;
      _energyController.text = dog.energy;
      _intensityController.text = dog.intensity;
      _exerciseNeedController.text = dog.exerciseNeed;
      _playfulnessController.text = dog.playfulness;
    } else {
      return Text("No data");
    }
  }


  Future<void> _save() async {

    DogtimeDog dog;
    if (widget.dog != null) {
      dog = widget.dog;

      dog.adaptsToApartment = _adaptsToApartmentController.text;
      dog.forNovice = _forNoviceController.text; 
      dog.sensitivity = _sensitivityController.text;
      dog.beingAlone = _beingAloneController.text;
      dog.coldWeather = _coldWeatherController.text;
      dog.hotWeather = _hotWeatherController.text;
      dog.familyFriendly = _familyFriendlyController.text;
      dog.kidFriendly = _kidFriendlyController.text;
      dog.dogFriendly = _dogFriendlyController.text;
      dog.strangerFriendly = _strangerFriendlyController.text;
      dog.shedding = _sheddingController.text;
      dog.drooling = _droolingController.text;
      dog.easyToGroom = _easyToGroomController.text;
      dog.health = _healthController.text;
      dog.weightGain = _weightGainController.text;
      dog.size = _sizeController.text;
      dog.trainingEase = _trainingEaseController.text;
      dog.iq = _iqController.text;
      dog.mouthiness = _mouthinessController.text;
      dog.preyDrive = _preyDriveController.text;
      dog.barking = _barkingController.text;
      dog.wanderlust = _wanderlustController.text;
      dog.energy = _energyController.text;
      dog.intensity = _intensityController.text;
      dog.exerciseNeed = _exerciseNeedController.text;
      dog.playfulness = _playfulnessController.text;
    } 

    saveCharacteristics(widget.dog, widget.breedId);
  }

  void clear() {
    _adaptsToApartmentController.clear();
    _forNoviceController.clear();
    _sensitivityController.clear();
    _beingAloneController.clear();
    _coldWeatherController.clear();
    _hotWeatherController.clear();
    _familyFriendlyController.clear();
    _kidFriendlyController.clear();
    _dogFriendlyController.clear();
    _strangerFriendlyController.clear();
    _sheddingController.clear();
    _droolingController.clear();
    _easyToGroomController.clear();
    _healthController.clear();
    _weightGainController.clear();
    _sizeController.clear();
    _trainingEaseController.clear();
    _iqController.clear();
    _mouthinessController.clear();
    _preyDriveController.clear();
    _barkingController.clear();
    _wanderlustController.clear();
    _energyController.clear();
    _intensityController.clear();
    _exerciseNeedController.clear();
    _playfulnessController.clear();
    
  }

}
