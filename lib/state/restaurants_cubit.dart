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
            address: 'Námestie 1. mája 18',
            image:
                'https://media.istockphoto.com/photos/modern-caffe-interior-with-long-bar-picture-id1032250912?k=20&m=1032250912&s=612x612&w=0&h=ywXZhJ_yUQ9HS6wkG6lrNZCDWDMQx15zbVD99ewaDf8='),
        Restaurant(
            id: 2,
            name: 'Hostinec u Deda',
            address: 'Zálužická 49',
            image:
                'https://hostinecudeda.sk/wp-content/uploads/2016/06/hostinecudeda-8-1030x687.jpg'),
        Restaurant(
            id: 3,
            name: 'Basilicò',
            address: 'Dunajská 25',
            image:
                'https://media-cdn.tripadvisor.com/media/photo-s/1b/3b/60/7e/basilico.jpg')
      ]..shuffle();
      emit(newState);
    });
  }

  Restaurant getRestaurantById(int id) {
    return state.firstWhere((restaurant) => restaurant.id == id);
  }
}
