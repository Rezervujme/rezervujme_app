import 'package:vrouter/vrouter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  Future<void> refreshRestaurants() async {
    await context.read<RestaurantsCubit>().fetchRestaurants();
  }

  @override
  void initState() {
    context.read<RestaurantsCubit>().fetchRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Reštaurácie'),
      ),
      // bottomNavigationBar: Container(),
      body: BlocBuilder<RestaurantsCubit, List<Restaurant>>(
        builder: (context, state) {
          print(state.toString());
          return state.isEmpty
              ? const Center(child: CircularProgressIndicator.adaptive())
              : RefreshIndicator(
                  onRefresh: refreshRestaurants,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 16, top: 16),
                            child: Text('Test')),
                        SizedBox(
                          height: 172.8,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.length,
                              itemBuilder: (context, index) {
                                final restaurant = state[index];
                                return RestaurantCard(restaurant: restaurant);
                              }),
                        ),
                        SizedBox(
                          height: 172.8,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.length,
                              itemBuilder: (context, index) {
                                final restaurant = state[index];
                                return RestaurantCard(restaurant: restaurant);
                              }),
                        ),
                        SizedBox(
                          height: 172.8,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.length,
                              itemBuilder: (context, index) {
                                final restaurant = state[index];
                                return RestaurantCard(restaurant: restaurant);
                              }),
                        ),
                        SizedBox(
                          height: 172.8,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.length,
                              itemBuilder: (context, index) {
                                final restaurant = state[index];
                                return RestaurantCard(restaurant: restaurant);
                              }),
                        ),
                        SizedBox(
                          height: 172.8,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.length,
                              itemBuilder: (context, index) {
                                final restaurant = state[index];
                                return RestaurantCard(restaurant: restaurant);
                              }),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: 200,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.vRouter.to('/tabs/restaurants/${restaurant.id}'),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: restaurant.image),
              ),
              Container(
                child: Text(
                  restaurant.name,
                ),
                margin: const EdgeInsets.only(top: 4, bottom: 4),
              ),
              Container(
                child: Text(restaurant.address),
                margin: const EdgeInsets.only(top: 4, bottom: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
