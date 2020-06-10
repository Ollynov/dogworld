import 'package:doggies/services/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../../services/services.dart';
import './../../shared/shared.dart';
import 'package:provider/provider.dart';


class EditBreedScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final UsersService userService = UsersService();

  @override
  Widget build(BuildContext context) {
    
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    // UserDetails userDetails = Provider.of<UserDetails>(context);


    if (user != null) {
      return Scaffold(
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
              BreedListDropDown()
          ],
        ),
            )),
        bottomNavigationBar: AppBottomNav(route: 2, inactive: false,),
      );
    } else {
      return LoadingScreen();
    }
  }
}


// class BreedListDropDown extends StatefulWidget {
//   BreedListDropDown({Key key}) : super(key: key);

//   @override
//   _BreedListDropDownState createState() => _BreedListDropDownState();
// }

// class _BreedListDropDownState extends State<BreedListDropDown> {
//   String dropdownValue = 'One';

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Collection<Breed>(path: 'allBreeds').getData(),
//       builder: (BuildContext context, AsyncSnapshot<List<Breed>> snapshot) { 

//         if (snapshot.data != null) {
//           List<Breed> allBreeds = snapshot.data;
//           List<String> onlyNames = [];
          
//           snapshot.data.forEach((dog) => {
//             if (!onlyNames.contains(dog.id)) {
//               onlyNames.add(dog.id)
//             }
//           });

//           return DropdownButton<String>(
//             value: dropdownValue,
//             icon: Icon(Icons.arrow_downward),
//             iconSize: 24,
//             elevation: 16,
//             // style: TextStyle(color: Theme.of(context).primaryColor),
//             underline: Container(
//               height: 2,
//               // color: Theme.of(context).primaryColor,
//             ),
//             onChanged: (String newValue) {
//               setState(() {
//                 dropdownValue = newValue;
//               });
//             },
//             items: <String>["doberman", "labrador"].map<DropdownMenuItem<String>>((String name) {

//               // if (storage[breed.id] == 1) {
//               //     print('ok found dup here: ');
//               //     print(storage[breed.id]);
//               //   } else {
//               //     storage[breed.id] = 1;
//               //   }
  
//               return DropdownMenuItem<String>(
//                 value: name,
//                 child: Text(name),
//               );
//             }).toList(),
//           );
//         } else {
//           return Text("hmm");
//         }
//       }
//     );
//   }
// }

class BreedListDropDown extends StatefulWidget {
  BreedListDropDown({Key key}) : super(key: key);

  @override
  _BreedListDropDownState createState() => _BreedListDropDownState();
}

class _BreedListDropDownState extends State<BreedListDropDown> {
  String dropdownValue = 'Affenpinscher';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
       future: Collection<Breed>(path: 'allBreeds').getData(),
       builder: (BuildContext context, AsyncSnapshot<List<Breed>> snapshot) { 
        List<Breed> allBreeds = snapshot.data;
        List<String> onlyNames = [];
        
        snapshot.data.forEach((dog) => {
          if (!onlyNames.contains(dog.id)) {
            onlyNames.add(dog.id)
          }
        });
         return DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: allBreeds
                .map<DropdownMenuItem<String>>((Breed value) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(value.id),
              );
            }).toList(),
          );


       }
    );
  }
}
