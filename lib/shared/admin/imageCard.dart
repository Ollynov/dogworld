import 'package:flutter/material.dart';

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
