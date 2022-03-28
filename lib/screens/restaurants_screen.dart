import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rezervujme_app/models/auth/auth.dart';
import 'package:rezervujme_app/models/category/category.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';
import 'package:vrouter/vrouter.dart';

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
    context.read<RestaurantsCubit>().fetchRestaurants().then((value) =>
        searchedRestaurants = context.read<RestaurantsCubit>().state);

    super.initState();
  }

//   List<Restaurant> searchRestaurants(String search) {
//     return state
//         .where((restaurant) => restaurant.name.startsWith(search))
//         .toList();
//   }
// }
  List<Restaurant>? searchedRestaurants;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: CupertinoSearchTextField(
                            placeholder: 'Hľadať reštauráciu...',
                            onChanged: (val) {
                              setState(() => searchedRestaurants = context
                                  .read<RestaurantsCubit>()
                                  .state
                                  .where(
                                      (element) => element.name.startsWith(val))
                                  .toList());
                            },
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                    const NotificationButton()
                  ],
                ),
              ),
            ),
          ),
        ),
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   title: const Text('Reštaurácie'),
        // ),
        // bottomNavigationBar: Container(),
        body: BlocBuilder<RestaurantsCubit, List<Restaurant>>(
          builder: (context, state) {
            return searchedRestaurants == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : RefreshIndicator(
                    onRefresh: refreshRestaurants,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: searchedRestaurants!.length + 1,
                                itemBuilder: (context, index) {
                                  // print(state.length);
                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: BlocBuilder<AuthCubit, Auth>(
                                              builder: (context, state) {
                                            return Text(
                                              "Ahoj, ${state.user?.name}!",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            );
                                          }),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                              "Kam si pôjdeš najbližšie sadnúť?"),
                                        ),
                                        if (searchedRestaurants!.isEmpty)
                                          Text(
                                              'Žiadne reštaurácie nevyhovujú vášmu hľadaniu',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption)
                                      ],
                                    );
                                  }
                                  final restaurant = state[index - 1];
                                  return RestaurantCard(restaurant: restaurant);
                                }),
                          ),
                        ],
                      ),
                    ),
                  );
          },
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
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.vRouter.to('/tabs/restaurants/${restaurant.id}'),
          child: Container(
            padding: EdgeInsets.all(4),
            child: Ink(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator.adaptive()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl:
                              'https://zellersrestaurants.com/wp-content/uploads/2019/11/Restaurant.jpg'),
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
            onTap: () => context.vRouter.to('/tabs/reservations'),
            child: Ink(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor,
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
                const Icon(
                  Icons.star_border_outlined,
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
