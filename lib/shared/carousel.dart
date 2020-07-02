import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Carousel extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();
  List images;
  Carousel({this.images});


  @override
  Widget build(BuildContext context) => Column(
    // children: <Widget>[
    children: [
      Stack(
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
                        // width: 440,
                        fit: BoxFit.contain,
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
            // height: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height * .36,
            viewportFraction: 2,
            // aspectRatio: 1,
            initialPage: 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .08),
          child: Opacity(
            opacity: .7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () => buttonCarouselController.previousPage(
                      duration: Duration(milliseconds: 300), curve: Curves.linear),
                  child: Icon(FontAwesomeIcons.arrowLeft),
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 80, bottom: 80),
                ),
                FlatButton(
                  onPressed: () => buttonCarouselController.nextPage(
                      duration: Duration(milliseconds: 300), curve: Curves.linear),
                  child: Icon(FontAwesomeIcons.arrowRight),
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 80, bottom: 80),
                )
              ],
            ),
          ),
        )
        ]
      ),

    ]
  );
}
