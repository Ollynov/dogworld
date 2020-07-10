import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/services/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



Future<void> saveBreed({String breedId, String description, String fullName, String lifeSpan, String bredFor, String breedGroup, String height, String weight, String origin, String img, dynamic additionalImages}) async {

  final Document<Breed> breedsRef = Document<Breed>(path: 'Breed/$breedId');

  additionalImages = additionalImages.split(", ");
  
  var toSave = {};
  // this is to avoid saving a blank string in our database as an "additional image"
  if (additionalImages != null && additionalImages[0] != "") {
    toSave = {
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
  } else {
    toSave = {
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
    };
  }


  final response = await breedsRef.upsert(toSave);
            // Scaffold.of(context).showSnackBar(SnackBar(
            //   content: GestureDetector(
            //     child: Text("You must be logged in to save a favorite dog breed."),
            //     onTap: () {Navigator.pushNamed(context, '/login');},
            //   ),
            //   backgroundColor: Theme.of(context).primaryColorLight,
            // ));
            // print('this is what we got');
            // print(response);
  final ourBreedsListRef = Firestore.instance.collection("allBreeds").document('ourBreeds');
  ourBreedsListRef.updateData({
    "ourBreeds": FieldValue.arrayUnion([breedId])
  });
  return response;
}



Future<Breed> fetchBreedFromDogWorld(String breedId) async {

  final Document<Breed> breedsRef = Document<Breed>(path: 'Breed/$breedId');
  final fromOurDb = await breedsRef.getData();
  return fromOurDb;
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

Future<Breed> fetchBreedFromDogtime(String breedId) async {

    final String breedId = "labrador-retriever";
    var body = json.encode({"text": "https://dogtime.com/dog-breeds/$breedId"});

    final response = await http.post('http://localhost:5000/dogworldio/us-central1/scrapeDogTime?breed=$breedId', headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var decoded = json.decode(response.body);
      print('ok got this body back: ');
      print(response.body);
      if (decoded.length > 0) {
        // before we return, let's get the image:
        
        return decoded;

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

