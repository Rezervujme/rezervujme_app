import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:rezervujme_app/extensions/string.dart';
import 'package:rezervujme_app/models/restaurant/restaurant.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';
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
  int? _selectedTable;

  Future<void> getAvailableTimes() async {
    var data = await Dio().get(
        '${dotenv.get('APP_URL')}/public/api/v1/restaurants/${_restaurant.id}/timeperiods',
        queryParameters: {'date': _reservationDate.toIso8601String()});
    print(data.data);
  }

  @override
  void initState() {
    _reservationDate = DateTime.parse(widget.reservationDateString);
    _restaurant =
        context.read<RestaurantsCubit>().getRestaurantById(widget.restaurantId);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.value =
          Matrix4.identity() * (MediaQuery.of(context).size.width / 772);
    });

    getAvailableTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).primaryColor,
          title: Column(
            children: [
              Text(
                'Objednávka',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Text(
                '${DateFormat.EEEE('sk').format(_reservationDate).capitalize()}, ${DateFormat.Md('sk').format(_reservationDate)}',
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
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
                    child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _selectedTable = null;
                        });
                      },
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
                                child: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      _selectedTable = 1;
                                    });
                                  },
                                  child: OrderTable(
                                    tableState: _selectedTable == 1
                                        ? TableState.selected
                                        : TableState.available,
                                    tableType: TableType.square,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 128,
                                left: 128,
                                child: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      _selectedTable = 2;
                                    });
                                  },
                                  child: OrderTable(
                                    tableState: _selectedTable == 2
                                        ? TableState.selected
                                        : TableState.available,
                                    tableType: TableType.square,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 512,
                                left: 64,
                                child: GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      _selectedTable = 2;
                                    });
                                  },
                                  child: OrderTable(
                                    tableState: TableState.reserved,
                                    tableType: TableType.square,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                          label: _restaurant.name, icon: Icons.house_outlined),
                      OrderItem(
                          label: _selectedTable != null
                              ? 'Stôl $_selectedTable - pre 4 osoby'
                              : 'Vyberte stôl',
                          icon: Icons.table_chart_outlined),
                      OrderItem(
                          label:
                              '${context.read<AuthCubit>().state.user!.name} ${context.read<AuthCubit>().state.user!.surname}',
                          icon: Icons.person_outlined),
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
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Poznámka',
                            ),
                            TextField(
                              minLines: 2,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: const TextStyle(fontSize: 13),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Nepovinné',
                                  hintStyle: const TextStyle(fontSize: 13),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1.5))),
                            )
                          ],
                        ),
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
                      onPressed:
                          _reservationTime == null || _selectedTable == null
                              ? null
                              : () => context.vRouter.to('/order-success'),
                      child: Text('Záväzne objednať')),
                ),
              ],
            ),
          ),
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

enum TableState { available, reserved, selected }
enum TableType { square, circle }

class OrderTable extends StatelessWidget {
  OrderTable({Key? key, required this.tableState, required this.tableType})
      : super(key: key);

  TableState tableState;
  TableType tableType;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: tableState == TableState.reserved ? 0.3 : 1,
      child: Container(
        width: 32,
        height: 32,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 7.11,
                height: 7.11,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.black,
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      stops: [0.5, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 7.11,
                height: 7.11,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.black,
                      ],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      stops: [0.5, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 7.11,
                height: 7.11,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.black,
                      ],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      stops: [0.5, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 7.11,
                height: 7.11,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.black,
                      ],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft,
                      stops: [0.5, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 28.44,
                height: 28.44,
                decoration: BoxDecoration(
                  color: tableState == TableState.selected
                      ? Colors.blue
                      : Theme.of(context).primaryColor,
                  borderRadius: tableType == TableType.circle
                      ? BorderRadius.circular(100)
                      : BorderRadius.circular(2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
