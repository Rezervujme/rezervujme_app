import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rezervujme_app/extensions/string.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(1, 3))
              ]),
          child: IconButton(
            tooltip: 'Späť',
            onPressed: () => context.vRouter.pop(),
            icon: Icon(
              Icons.chevron_left_outlined,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 150),
                child: Column(
                  children: [
                    SizedBox(
                      height: 320,
                      child: Stack(
                        children: [
                          Stack(children: [
                            SizedBox(
                              width: double.infinity,
                              height: 256,
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://zellersrestaurants.com/wp-content/uploads/2019/11/Restaurant.jpg',
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
                                    stops: const [0.0, 1.0],
                                  )),
                            ),
                          ]),
                          Positioned(
                            top: 192,
                            child: Container(
                              height: 128,
                              width: MediaQuery.of(context).size.width - 64,
                              margin:
                                  const EdgeInsets.only(left: 32, right: 32),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    _restaurant.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(_restaurant.address),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      child: Column(
                        children: [
                          Text(_restaurant.description),
                          const Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 6),
                            child: Align(
                              child: Text(
                                'Otváracie hodiny',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          Text(_restaurant.openingHours)
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                    )
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
                          offset:
                              const Offset(0, -4), // changes position of shadow
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
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 60)),
                                  locale: const Locale('sk'));
                              setState(() {
                                if (date != null) {
                                  _reservationDate = date;
                                }
                              });
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          child: const Icon(
                                              Icons.calendar_today_outlined)),
                                      Text(_reservationDate == null
                                          ? 'Vyberte deň rezervácie'
                                          : '${DateFormat.EEEE('sk').format(_reservationDate!).capitalize()}, ${DateFormat.Md('sk').format(_reservationDate!)}'),
                                    ]),
                                    const Icon(Icons.chevron_right_outlined),
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
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, top: 8),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                ),
                                onPressed: _reservationDate == null
                                    ? null
                                    : () => context.vRouter.to(
                                        '/tabs/restaurants/${_restaurant.id}/order/${_reservationDate!.toIso8601String()}'),
                                child: const Text('Vybrať stôl')),
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
