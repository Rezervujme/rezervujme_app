import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rezervujme_app/extensions/string.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';
import 'package:vrouter/vrouter.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key? key, required this.restaurantId})
      : super(key: key);

  final int restaurantId;

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Restaurant _restaurant;

  DateTime? _reservationDate;

  @override
  void initState() {
    _restaurant =
        context.read<RestaurantsCubit>().getRestaurantById(widget.restaurantId);
    initializeDateFormatting('sk');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(64),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: IconButton(
            splashRadius: 24,
            onPressed: () => context.vRouter.pop(),
            icon: Icon(
              Icons.chevron_left_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: IconButton(
              splashRadius: 24,
              onPressed: () => context.vRouter.pop(),
              icon: Icon(
                Icons.star_border_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 150),
                child: Column(
                  children: [
                    Container(
                      height: 320,
                      child: Stack(
                        children: [
                          Stack(children: [
                            Container(
                              width: double.infinity,
                              height: 256,
                              child: CachedNetworkImage(
                                imageUrl: _restaurant.image,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              height: 256,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor,
                                      Colors.black.withOpacity(0),
                                    ],
                                    stops: [0.0, 1.0],
                                  )),
                            ),
                          ]),
                          Positioned(
                            top: 192,
                            child: Container(
                              height: 128,
                              width: MediaQuery.of(context).size.width - 64,
                              margin: EdgeInsets.only(left: 32, right: 32),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(_restaurant.name),
                                  Text(_restaurant.address),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                          ),
                                          Text('1km'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.emoji_emotions_outlined,
                                            size: 16,
                                          ),
                                          Text('4.7'),
                                        ],
                                      ),
                                      Text('€€€'),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                    Text('test'),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 146,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 16,
                          offset: Offset(0, -4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Material(
                          child: InkWell(
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 60)),
                                  locale: Locale('sk'));
                              setState(() {
                                if (date != null) {
                                  _reservationDate = date;
                                }
                              });
                            },
                            child: Ink(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: Icon(
                                              Icons.calendar_today_outlined)),
                                      Text(_reservationDate == null
                                          ? 'Vyberte deň rezervácie'
                                          : '${DateFormat.EEEE('sk').format(_reservationDate!).capitalize()}, ${DateFormat.Md('sk').format(_reservationDate!)}'),
                                    ]),
                                    Icon(Icons.chevron_right_outlined),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          top: false,
                          left: false,
                          right: false,
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            margin:
                                EdgeInsets.only(left: 16, right: 16, top: 8),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                ),
                                onPressed: _reservationDate == null
                                    ? null
                                    : () => context.vRouter.to(
                                        '/tabs/restaurants/${_restaurant.id}/order/${_reservationDate!.toIso8601String()}'),
                                child: Text('Vybrať stôl')),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
