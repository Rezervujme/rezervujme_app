import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rezervujme_app/extensions/string.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
import 'package:rezervujme_app/state/restaurants_cubit.dart';
import 'package:vrouter/vrouter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen(
      {Key? key,
      required this.restaurantId,
      required this.reservationDateString})
      : super(key: key);

  final int restaurantId;

  final String reservationDateString;

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TransformationController _controller = TransformationController();

  late Restaurant _restaurant;
  late DateTime _reservationDate;
  TimeOfDay? _reservationTime;

  @override
  void initState() {
    _reservationDate = DateTime.parse(widget.reservationDateString);
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
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text(_restaurant.name),
    //     ),
    //     body: Column(
    //       children: [
    //         CachedNetworkImage(
    //             fit: BoxFit.fitWidth,
    //             placeholder: (context, url) =>
    //                 const CircularProgressIndicator.adaptive(),
    //             errorWidget: (context, url, error) => const Icon(Icons.error),
    //             imageUrl: _restaurant.image),
    //         AspectRatio(
    //           aspectRatio: 1,
    //           child: Container(
    //             decoration: BoxDecoration(border: Border.all()),
    //             width: double.infinity,
    //             child: InteractiveViewer(
    //               minScale: 0.1,
    //               maxScale: 4,
    //               transformationController: _controller,
    //               constrained: false,
    //               child: SizedBox(
    //                 width: 768,
    //                 height: 768,
    //                 child: Stack(
    //                   children: [
    //                     Positioned(
    //                       top: 32,
    //                       left: 32,
    //                       child: Container(
    //                         height: 32,
    //                         width: 32,
    //                         color: Colors.red,
    //                       ),
    //                     ),
    //                     Positioned(
    //                       top: 96,
    //                       left: 736,
    //                       child: Container(
    //                         height: 32,
    //                         width: 32,
    //                         color: Colors.red,
    //                       ),
    //                     ),
    //                     Positioned(
    //                       top: 128,
    //                       left: 704,
    //                       child: Container(
    //                         height: 32,
    //                         width: 32,
    //                         color: Colors.red,
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => context.vRouter.pop(),
                  icon: Icon(Icons.chevron_left),
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 48),
                    child: Column(
                      children: [
                        Text(
                          'Výber stola',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          '${DateFormat.EEEE('sk').format(_reservationDate).capitalize()}, ${DateFormat.Md('sk').format(_reservationDate)}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border: Border.all(color: Colors.grey)),
              child: AspectRatio(
                aspectRatio: 1,
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
            ),
            Container(
              child: Text(
                'Detaily objednávky',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              child: Column(
                children: [
                  OrderItem(
                      label: 'Stôl pre 4 osoby',
                      icon: Icons.table_chart_outlined),
                  OrderItem(
                      label: 'Jakub Jelínek', icon: Icons.person_outlined),
                  OrderItem(
                    label:
                        '${DateFormat.EEEE('sk').format(_reservationDate).capitalize()}, ${DateFormat.Md('sk').format(_reservationDate)}',
                    icon: Icons.calendar_today_outlined,
                  ),
                  OrderItem(
                    label: _reservationTime?.format(context) ??
                        'Vyberte čas rezervácie',
                    icon: Icons.access_time_outlined,
                    openTime: true,
                    callback: () async {
                      var time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        setState(() {
                          _reservationTime = time;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 48,
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => {},
                  // onPressed: _reservationDate == null
                  //     ? null
                  //     : () => {
                  //           context.vRouter.to(
                  //               '/tabs/restaurants/${_restaurant.id}/order/${_reservationDate!.toIso8601String()}')
                  //         },
                  child: Text('Záväzne objednať')),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem(
      {Key? key,
      required this.label,
      required this.icon,
      this.openTime = false,
      this.callback})
      : super(key: key);

  final String label;
  final IconData icon;
  final bool openTime;
  final Function? callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 16),
      child: InkWell(
        onTap: !openTime ? null : () => callback!(),
        child: Ink(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 8), child: Icon(icon)),
                    Text(label),
                  ],
                ),
                if (openTime) Icon(Icons.chevron_right_outlined)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
