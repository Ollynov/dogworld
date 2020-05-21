import 'db.dart';
import 'models.dart';
import 'services.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // Data Models
  static final Map models = {
    Breed: (data) => Breed.convertFromFireBaseMap(data),
    Quiz: (data) => Quiz.convertFromFireBaseMap(data),
    Report: (data) => Report.convertFromFireBaseMap(data),
  };

  // Firestore References for Writes
  static final Collection<Breed> breedsRef = Collection<Breed>(path: 'Breed');
  static final UserData<Report> reportRef =
      UserData<Report>(collection: 'reports');
}
