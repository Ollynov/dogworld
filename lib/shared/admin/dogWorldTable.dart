import 'package:doggies/screens/admin/db.dart';
import 'package:doggies/services/models.dart';
import 'package:doggies/shared/admin/editAndSaveRow.dart';
import 'package:doggies/shared/admin/imageCard.dart';
import 'package:doggies/shared/admin/infoRow.dart';
import 'package:flutter/material.dart';

class BreedDetails extends StatefulWidget {
  final String breedId;
  final String dataSource;

  const BreedDetails({Key key, this.breedId, this.dataSource}) : super(key: key);

  @override
  _BreedDetailsState createState() => _BreedDetailsState();
}

class _BreedDetailsState extends State<BreedDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _lifeSpanController = TextEditingController();
  TextEditingController _bredForController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _additionalImagesController = TextEditingController();

  // void initState() {
  //   super.initState();
  //   _nameController = TextEditingController(text: "");
  // }

  // void dispose() {
  //   _nameController.dispose(); _descriptionController.dispose(); _lifeSpanController.dispose(); _bredForController.dispose(); _groupController.dispose(); _heightController.dispose(); _weightController.dispose(); _originController.dispose(); _imageController.dispose(); _additionalImagesController.dispose();
  //   super.dispose();
  // }



  // set copyValues(String value) => setState(() => _nameController.text = value);

  @override
  Widget build(BuildContext context) {
    _clear();

    return FutureBuilder(
      future: _fetchBreed(widget.dataSource),
      builder: (BuildContext context, AsyncSnapshot<Breed> value) {
      // builder: (BuildContext context, AsyncSnapshot<TempModel> value) {
        print('here is our values: ');
        print(value);
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
          if (value.data.additionalImages != null) {
            _additionalImagesController.text = value.data.additionalImages.join(', ');
          } else {
            _additionalImagesController.text = "";
          }
        } 

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                  children: [
                    Row(children: [
                      Text(widget.dataSource, style: Theme.of(context).textTheme.headline2)
                    ],),

                    InfoRow(text: "Name", controller: _nameController),
                    InfoRow(text: "Lifespan", controller: _lifeSpanController),
                    InfoRow(text: "Description", controller: _descriptionController),
                    InfoRow(text: "Bred For", controller: _bredForController),
                    InfoRow(text: "Group", controller: _groupController),
                    InfoRow(text: "Height", controller: _heightController),
                    InfoRow(text: "Weight", controller: _weightController),
                    InfoRow(text: "Origin", controller: _originController),
                    InfoRow(text: "Primary Image", controller: _imageController),

                  if (widget.dataSource == "Dog World")
                    InfoRow(text: "Additional Images", controller: _additionalImagesController),
                  EditAndSaveRow(source: widget.dataSource, breedId: widget.breedId, fullName: _nameController, description: _descriptionController, lifeSpan: _lifeSpanController, bredFor: _bredForController, breedGroup: _groupController, height: _heightController, weight: _weightController, origin: _originController, img: _imageController, additionalImages: _additionalImagesController),
                  
                  Row(
                    children: [
                      Column(children: [ImageCard(imagePath: _imageController.text)],),
                      if (widget.dataSource == "Dog World") 
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: _additionalImagesController.text.split(", ").map((imagePath) => 
                            ImageCard(imagePath: imagePath,)
                          ).toList(),),
                        )
                    ],
                  )
                ],),
          );
      }
    );
  }



  _fetchBreed(dataSource) {
    
    if (dataSource == "Dog CEO") {
      return fetchBreedFromDogCEO(widget.breedId);
    } else if (dataSource == "Dog World") {
      return fetchBreedFromDogWorld(widget.breedId);
    } 
  }

  void _clear() {
      _nameController.clear(); _descriptionController.clear(); _lifeSpanController.clear(); _bredForController.clear(); _groupController.clear(); _heightController.clear(); _weightController.clear(); _originController.clear(); _imageController.clear(); _additionalImagesController.clear();
  }
}
