import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rezervujme_app/models/category/category.dart';
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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   title: const Text('Reštaurácie'),
      // ),
      // bottomNavigationBar: Container(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: BlocBuilder<RestaurantsCubit, List<Restaurant>>(
            builder: (context, state) {
              print(state.toString());
              return state.isEmpty
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : RefreshIndicator(
                      onRefresh: refreshRestaurants,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        child: CupertinoSearchTextField(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      )),
                                      const NotificationButton()
                                    ]),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Ahoj, Matej!",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                    "Kam sa pôjdeš najbližšie najebať?"),
                              ),
                              SizedBox(
                                height: 128,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    CategoryCard(
                                      category: Category(
                                          id: 1,
                                          name: 'Romantické',
                                          iconId: 0xe25c),
                                    ),
                                    CategoryCard(
                                      category: Category(
                                          id: 1, name: 'Lacné', iconId: 0xf184),
                                    ),
                                    CategoryCard(
                                      category: Category(
                                          id: 1,
                                          name: 'Neformálne',
                                          iconId: 0xf188),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.length,
                                    itemBuilder: (context, index) {
                                      final restaurant = state[index];
                                      return RestaurantCard(
                                          restaurant: restaurant);
                                    }),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.length,
                                    itemBuilder: (context, index) {
                                      final restaurant = state[index];
                                      return RestaurantCard(
                                          restaurant: restaurant);
                                    }),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.length,
                                    itemBuilder: (context, index) {
                                      final restaurant = state[index];
                                      return RestaurantCard(
                                          restaurant: restaurant);
                                    }),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.length,
                                    itemBuilder: (context, index) {
                                      final restaurant = state[index];
                                      return RestaurantCard(
                                          restaurant: restaurant);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                padding: EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: restaurant.image),
                ),
              ),
              Container(
                child: Text(
                  restaurant.name,
                ),
                margin: const EdgeInsets.all(4),
              ),
              Container(
                child: Text(restaurant.address),
                margin: const EdgeInsets.all(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  bool isUnread = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 36,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => {},
            child: Ink(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  backgroundBlendMode: BlendMode.color),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(right: 2),
              alignment: Alignment.topRight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    width: 12,
                    height: 12,
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  const CategoryCard({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: () => {},
        child: SizedBox(
          width: 128,
          child: Ink(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(
                  IconData(widget.category.iconId, fontFamily: 'MaterialIcons'),
                  size: 64,
                ),
                Text(
                  widget.category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ])),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
