import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key? key, required this.restaurantId})
      : super(key: key);

  final int restaurantId;

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final TransformationController _controller = TransformationController();

  late Restaurant _restaurant;

  @override
  void initState() {
    _restaurant =
        context.read<RestaurantsCubit>().getRestaurantById(widget.restaurantId);
    print('loaded');
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.value =
          Matrix4.identity() * (MediaQuery.of(context).size.width / 772);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_restaurant.name),
        ),
        body: Column(
          children: [
            CachedNetworkImage(
                fit: BoxFit.fitWidth,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: _restaurant.image),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                width: double.infinity,
                child: InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 4,
                  transformationController: _controller,
                  constrained: false,
                  child: SizedBox(
                    width: 768,
                    height: 768,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 32,
                          left: 32,
                          child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.red,
                          ),
                        ),
                        Positioned(
                          top: 96,
                          left: 736,
                          child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.red,
                          ),
                        ),
                        Positioned(
                          top: 128,
                          left: 704,
                          child: Container(
                            height: 32,
                            width: 32,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
