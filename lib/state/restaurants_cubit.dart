import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';

class RestaurantsCubit extends Cubit<List<Restaurant>> {
  RestaurantsCubit() : super([]);

  Future<void> fetchRestaurants() async {
    var data =
        await Dio().get('${dotenv.get('APP_URL')}/public/api/v1/restaurants');
    List<Restaurant> newState = (data.data['data'] as List<dynamic>)
        .map((e) => Restaurant.fromJson(e))
        .toList();
    emit(newState);
  }

  Restaurant getRestaurantById(int id) {
    return state.firstWhere((restaurant) => restaurant.id == id);
  }
}
