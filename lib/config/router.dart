import 'package:doggies/screens/breed.dart';
import 'package:fluro/fluro.dart' as Fluro;
import 'package:flutter/widgets.dart';

var rootHandler = Fluro.Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BreedScreen(breedId: params["id"][0]);
});

class Routes {

  static void configureRoutes(Fluro.Router router) {

    router.define('/breed/:id', handler: rootHandler);
  }
}
