import 'package:doggies/screens/breed.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BreedScreen(breedId: params["id"][0]);
});

class Routes {

  static void configureRoutes(Router router) {

    router.define('/breed/:id', handler: rootHandler);
  }
}
