import 'package:doggies/screens/admin/db.dart';
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
  TextEditingController _descriptionController = TextEditingController();

  // void initState() {
  //   super.initState();
  //   _descriptionController = TextEditingController();
  // }

  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void clear() {
    _descriptionController.clear(); 
  }
  @override
  Widget build(BuildContext context) {
    // _controller.text = widget.data;

    return FutureBuilder(
      future: fetchBreedFromDogtime(widget.breedId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> value) {
        
        if (value != null && value.data != null) {
          _descriptionController.text = value.data.description;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Dogtime", style: Theme.of(context).textTheme.headline2)
                  ],
                ),
                InfoRow(text: "Description", controller: _descriptionController)
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
