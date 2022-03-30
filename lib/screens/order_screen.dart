import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  late List<dynamic> _availableTimes;
  List<dynamic>? _tableView;
  TimeOfDay? _reservationTime;
  dynamic _selectedTable;
  String note = '';

  Future<void> fetchAvailableTimes() async {
    var data = await Dio().get(
        '${dotenv.get('APP_URL')}/public/api/v1/restaurants/${_restaurant.id}/timeperiods',
        queryParameters: {'date': _reservationDate.toIso8601String()});
    setState(() {
      _availableTimes = data.data['data'];
      if (kDebugMode) {
        print(_availableTimes);
      }
    });
  }

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime.utc(
        date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> getTableView() async {
    var data = await Dio().get(
        '${dotenv.get('APP_URL')}/public/api/v1/restaurants/${_restaurant.id}/tableviews',
        options: Options(headers: {
          'Authorization': 'Bearer ${context.read<AuthCubit>().state.token}'
        }));
    setState(() {
      _tableView = data.data['data'];
      if (kDebugMode) {
        print(_tableView);
      }
    });
  }

  List<dynamic> getTimes() {
    return _availableTimes.firstWhere((element) =>
        element.keys.elementAt(0) ==
        _selectedTable['uuid'])[_selectedTable['uuid']];
  }

  Future<void> orderTable() async {
    try {
      await Dio().post('${dotenv.get('APP_URL')}/api/v1/reservations',
          data: {
            'table_id': _selectedTable['uuid'],
            'from': join(_reservationDate, _reservationTime!).toIso8601String(),
            'to': join(_reservationDate, _reservationTime!)
                .add(const Duration(hours: 2))
                .toIso8601String(),
            'note': note
          },
          options: Options(headers: {
            'Authorization': 'Bearer ${context.read<AuthCubit>().state.token}'
          }));
      context.vRouter.to('/order-success');
      _selectedTable = null;
      _reservationTime = null;
    } catch (err) {
      if (err is DioError) {
        if (err.response?.data['error'] != null) {
          var snackBar = SnackBar(
            content: Text(err.response?.data['error']),
            duration: const Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          var snackBar = const SnackBar(
            content: Text('An unknown error has occurred.'),
            duration: Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
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
    getTableView();
    fetchAvailableTimes();
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
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
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
                          _reservationTime = null;
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
                              if (_tableView != null)
                                ..._tableView!
                                    .firstWhere((element) =>
                                        _restaurant.primaryTableView != null
                                            ? element['id'] ==
                                                _restaurant
                                                    .primaryTableView['id']
                                            : true)['tables']
                                    .map(
                                      (table) => Positioned(
                                        left: table['position']['x'].toDouble(),
                                        top: table['position']['y'].toDouble(),
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            setState(() {
                                              _selectedTable = table;
                                              _reservationTime = null;
                                            });
                                          },
                                          child: OrderTable(
                                            tableState: table['uuid'] ==
                                                    _selectedTable?['uuid']
                                                ? TableState.selected
                                                : TableState.available,
                                            tableType:
                                                table['shape'] == 'square'
                                                    ? TableType.square
                                                    : TableType.circle,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Detaily objednávky',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Column(
                  children: [
                    OrderItem(
                        label: _restaurant.name, icon: Icons.house_outlined),
                    OrderItem(
                        label: _selectedTable != null
                            ? 'Stôl ${_selectedTable['label']} - pre 4 osoby'
                            : 'Vyberte stôl',
                        icon: Icons.location_on_outlined),
                    OrderItem(
                        label:
                            '${context.read<AuthCubit>().state.user!.name} ${context.read<AuthCubit>().state.user!.surname}',
                        icon: Icons.person_outlined),
                    OrderItem(
                      label:
                          '${DateFormat.EEEE('sk').format(_reservationDate).capitalize()}, ${DateFormat.Md('sk').format(_reservationDate)}',
                      icon: Icons.calendar_today_outlined,
                    ),
                    if (_selectedTable != null)
                      OrderItem(
                        label: _reservationTime?.format(context) ??
                            'Vyberte čas rezervácie',
                        icon: Icons.access_time_outlined,
                        openTime: true,
                        callback: () async {
                          if (_selectedTable == null) return;
                          showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      systemOverlayStyle:
                                          SystemUiOverlayStyle.dark,
                                      foregroundColor: Colors.black,
                                      title:
                                          const Text('Vyberte čas rezervácie'),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      leading: const Text(''),
                                      actions: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                                Icons.close_outlined))
                                      ],
                                    ),
                                    body: ListView.separated(
                                        itemCount: getTimes().length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(TimeOfDay.fromDateTime(
                                                    DateTime.parse(
                                                        getTimes()[index]))
                                                .format(context)),
                                            onTap: () {
                                              setState(() {
                                                _reservationTime =
                                                    TimeOfDay.fromDateTime(
                                                        DateTime.parse(
                                                            getTimes()[index]));
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider();
                                        }),
                                  ));
                        },
                      ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Poznámka',
                          ),
                          TextField(
                            minLines: 2,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) => note = value,
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
                Container(
                  width: double.infinity,
                  height: 48,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed:
                          _reservationTime == null || _selectedTable == null
                              ? null
                              : orderTable,
                      child: const Text('Záväzne objednať')),
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
                        margin: const EdgeInsets.only(right: 8),
                        child: Icon(icon)),
                    Text(label),
                  ],
                ),
                if (openTime) const Icon(Icons.chevron_right_outlined)
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
  const OrderTable(
      {Key? key, required this.tableState, required this.tableType})
      : super(key: key);

  final TableState tableState;
  final TableType tableType;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: tableState == TableState.reserved ? 0.3 : 1,
      child: SizedBox(
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
                  gradient: const LinearGradient(
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
                  gradient: const LinearGradient(
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
                  gradient: const LinearGradient(
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
                  gradient: const LinearGradient(
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
