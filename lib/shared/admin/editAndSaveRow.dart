import 'package:doggies/screens/admin/db.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditAndSaveRow extends StatelessWidget {
  final String source;
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

  const EditAndSaveRow({Key key, this.breedId, this.fullName, this.description, this.lifeSpan, this.bredFor, this.breedGroup, this.height, this.weight, this.origin, this.img, this.additionalImages, this.source}) : super(key: key);


  @override
    Widget build(BuildContext context) {

      _showDialog() {
        // flutter defined function
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Warning!"),
              content: new Text("This will overwrite everything we have in our DB, are you sure?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Accept"),
                  onPressed: () {
                    saveBreed(breedId: breedId, fullName: fullName.text, description: description.text, lifeSpan: lifeSpan.text, bredFor: bredFor.text, breedGroup: breedGroup.text, height: height.text, weight: weight.text, origin: origin.text, img: img.text, additionalImages: additionalImages.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RaisedButton.icon(
              onPressed: (source == "Dog CEO") ? 
                () => _showDialog()
              : () => {
                saveBreed(breedId: breedId, fullName: fullName.text, description: description.text, lifeSpan: lifeSpan.text, bredFor: bredFor.text, breedGroup: breedGroup.text, height: height.text, weight: weight.text, origin: origin.text, img: img.text, additionalImages: additionalImages.text)
                // .then((value) => print(value))
              }, 
              padding: EdgeInsets.all(16),
              icon: Icon(FontAwesomeIcons.save), 
              label: (source == "Dog CEO") ?
                  Text('Overwrite Database', style: TextStyle(fontSize: 22)) :
                  Text('Save', style: TextStyle(fontSize: 22))
            ),
          )
      ]),
    );
  }
}
