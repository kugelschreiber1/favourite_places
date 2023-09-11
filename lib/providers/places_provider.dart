import 'package:favourite_places/models/place_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  List<Place> getPlace(Place place) {
    return state = [...state, place];
  }

  void setPlace(Place place) {
    state = [...state, place];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
