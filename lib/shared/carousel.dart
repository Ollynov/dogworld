import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();
  List images;
  Carousel({this.images});


 @override
  Widget build(BuildContext context) => Column(
    // children: <Widget>[
    children: [
      CarouselSlider(
        items: images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                // return Container(
                //   width: MediaQuery.of(context).size.width,
                //   margin: EdgeInsets.symmetric(horizontal: 5.0),
                //   decoration: BoxDecoration(
                //     color: Colors.amber
                //   ),
                //   child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                // );
                return (image.split("//")[0] == "https:"? 
                    Image.network(
                      image, 
                      width: 440
                      // width: MediaQuery.of(context).size.width,
                      // height: 340,
                    ) :
                    Image.asset(
                      'assets/covers/$image',
                      width: MediaQuery.of(context).size.width,
                      // height: 430,
                    )
                  );
              },
            );
          }).toList(),
        carouselController: buttonCarouselController,
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          height: 310,
          viewportFraction: .9,
          aspectRatio: 3/2,
          initialPage: 0,
        ),
      ),
      RaisedButton(
        onPressed: () => buttonCarouselController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.linear),
        child: Text('→'),
      )
    ]
  );
}
