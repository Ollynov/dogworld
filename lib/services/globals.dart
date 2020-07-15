import 'db.dart';
import 'models.dart';
import 'services.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // Data Models, this object is just here so we don't need to keep importing the models. We are just making them globally available. 
  static final Map models = {
    Breed: (data) => Breed.convertFromFireBaseMap(data),
    Quiz: (data) => Quiz.convertFromFireBaseMap(data),
    Report: (data) => Report.convertFromFireBaseMap(data),
    UserDetails: (data) => UserDetails.convertFromFireBaseMap(data),
    DogtimeDog: (data) => DogtimeDog.fromJson(data),
  };

  // Firestore References for Writes
  static final Collection<Breed> breedsRef = Collection<Breed>(path: 'Breed');
  // static final Document<Breed> breedRef = Document<Breed>(path: 'Breed');
  static final UserData<Report> reportRef = UserData<Report>(collection: 'reports');
  static final UserData<UserDetails> userDetailsRef = UserData<UserDetails>(collection: 'users');
}
