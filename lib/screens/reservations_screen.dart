import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  List<dynamic> reservations = [];

  @override
  void initState() {
    // TODO: implement initState
    context.read<AuthCubit>().updateUser().then((value) {
      setState(() {
        reservations = context.read<AuthCubit>().state.user?.reservations ?? [];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Moje rezervácie',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.separated(
        itemCount: reservations.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          print(reservations);
          return ListTile(
            title: Text(reservations[index]['restaurant']['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${DateFormat.Md('sk').format(DateTime.parse(reservations[index]['from']))} ${DateTime.parse(reservations[index]['from']).hour}:${DateTime.parse(reservations[index]['from']).minute}'),
                Text(reservations[index]['note']),
              ],
            ),
          );
        },
      ),
    );
  }
}
