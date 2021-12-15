import 'package:bloc/bloc.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';

class RestaurantsCubit extends Cubit<List<Restaurant>> {
  RestaurantsCubit() : super([]);

  Future<void> fetchRestaurants() async {
    await Future.delayed(const Duration(seconds: 1), () {
      var newState = [
        Restaurant(
            id: 1,
            name: 'Primo Amore',
            address: 'Kollarko',
            image:
                'https://i.picsum.photos/id/237/1200/630.jpg?hmac=NV7OupHtLSM1agzr2beogbePuaTRXq3i7W1Es-TZfbw'),
        Restaurant(
            id: 2,
            name: 'U Deda',
            address: 'Ruzinov',
            image:
                'https://i.picsum.photos/id/236/1200/630.jpg?hmac=0iz9185-Q8RfpevWe0izctxPBnDpmKPwlauCOBMism4'),
        Restaurant(
            id: 3,
            name: 'Basilico',
            address: 'Kapucinska',
            image:
                'https://i.picsum.photos/id/235/1200/630.jpg?hmac=s5VslXcq5gBQjo6WCZBcOC36bFCASPWmtbaKhVkgkAY')
      ]..shuffle();
      emit(newState);
    });
  }

  Restaurant getRestaurantById(int id) {
    return state.firstWhere((restaurant) => restaurant.id == id);
  }
}
