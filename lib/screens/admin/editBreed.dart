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
        BreedDetails(breedId: dropdownValue, dataSource: "Dog World"),
        BreedDetails(breedId: dropdownValue, dataSource: "Dog CEO",)
      ],
    );
  }
}

class BreedDetails extends StatefulWidget {
  final String breedId;
  final String dataSource;
  const BreedDetails({Key key, this.breedId, this.dataSource}) : super(key: key);

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
  TextEditingController _imageController;
  TextEditingController _additionalImagesController;

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
    _imageController = TextEditingController();
    if (widget.dataSource == "Dog World") 
      _additionalImagesController = TextEditingController();
  }

  void dispose() {
    _nameController.dispose(); _descriptionController.dispose(); _lifeSpanController.dispose(); _bredForController.dispose(); _groupController.dispose(); _heightController.dispose(); _weightController.dispose(); _originController.dispose(); _imageController.dispose(); _additionalImagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _fetchBreed(widget.dataSource),
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
          _imageController.text = value.data.img;
          if (widget.dataSource == "Dog World") 
            _additionalImagesController.text = value.data.additionalImages.join(', ');

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                  children: [
                    Row(children: [
                      Text(widget.dataSource, style: Theme.of(context).textTheme.headline2)
                    ],),
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
                    Row(children: [
                      TitleColumn(text: 'Primary Image'),
                      Flexible(child: 
                        TextField(
                          controller: _imageController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],),

                  if (widget.dataSource == "Dog World") 
                    Row(children: [
                      TitleColumn(text: 'Additional Images'),
                      Flexible(child: 
                        TextField(
                          controller: _additionalImagesController,
                          style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],),
                    // this should only be displayed if it's Dog World
                    EditAndSaveRow(breedId: widget.breedId, fullName: _nameController, description: _descriptionController, lifeSpan: _lifeSpanController, bredFor: _bredForController, breedGroup: _groupController, height: _heightController, weight: _weightController, origin: _originController, img: _imageController, additionalImages: _additionalImagesController),
                  
                  ImageCard(imagePath: _imageController.text) 
                ],),
          );
        } else {
          return Loader();
        }
      }
    );
  }

  _fetchBreed(dataSource) {
    //widget.breedId
    if (dataSource == "Dog CEO") {
      return fetchBreedFromDogCEO(widget.breedId);
    } else if (dataSource == "Dog World") {
      return fetchBreedFromDogWorld(widget.breedId);
    }
    
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

  const EditAndSaveRow({Key key, this.breedId, this.fullName, this.description, this.lifeSpan, this.bredFor, this.breedGroup, this.height, this.weight, this.origin, this.img, this.additionalImages}) : super(key: key);

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
                saveBreed(breedId: breedId, fullName: fullName.text, description: description.text, lifeSpan: lifeSpan.text, bredFor: bredFor.text, breedGroup: breedGroup.text, height: height.text, weight: weight.text, origin: origin.text, img: img.text, additionalImages: additionalImages.text)
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

Future<void> saveBreed({String breedId, String description, String fullName, String lifeSpan, String bredFor, String breedGroup, String height, String weight, String origin, String img, dynamic additionalImages}) async {
  print('here is breedId: ');
  print(breedId);
  final Document<Breed> breedsRef = Document<Breed>(path: 'Breed/$breedId');

  additionalImages = additionalImages.split(", ");
  print('ok here is what we will save: ');
  print(additionalImages);
  
  final toSave = {
    "id": breedId,
    "fullName": fullName, 
    "description": description,
    "lifeSpan": lifeSpan,
    "bredFor": bredFor,
    "breedGroup": breedGroup,
    "height": height,
    "weight": weight,
    "origin": origin,
    "img": img,
    "additionalImages": additionalImages
  };

  final response = await breedsRef.upsert(toSave);
  return response;
}


class ImageCard extends StatelessWidget {
  final String imagePath;
  const ImageCard({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 240,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: 
                Image.network(
                  imagePath, 
                  fit: BoxFit.contain,
                ) 
            ),
          ),
        ],
      ),
    );
  }
}





Future<Breed> fetchBreedFromDogWorld(String breedId) async {

  // THIS NEEDS TO PERIORITIZE GRABBING FROM OUR OWN DB FIRST
  final Document<Breed> breedsRef = Document<Breed>(path: 'Breed/$breedId');
  final fromOurDb = await breedsRef.getData();

  print('here is what we got: ');
  print(fromOurDb);

  return fromOurDb;

  // if (fromOurDb != null) {
  //   print('ok got some goodi back: ');
  //   print(fromOurDb.fullName);
  //   return fromOurDb;

  // } 
}

Future<Breed> fetchBreedFromDogCEO(String breedId) async {


    final response = await http.get('https://api.thedogapi.com/v1/breeds/search?q=$breedId');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var decoded = json.decode(response.body);
      if (decoded.length > 0) {
        // before we return, let's get the image:
        Breed ourBreed = Breed.fromJsonDogAPI(decoded[0]);
        int dogApiId = ourBreed.dogApiId;
        final image = await http.get('https://api.thedogapi.com/v1/images/search?include_breed=1&breed_id=$dogApiId');
        var decodedImage = json.decode(image.body)[0];
        Breed ourImage = Breed.fromJsonDogAPIJustImage(decodedImage);
        ourBreed.img = ourImage.img;
        return ourBreed;

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

