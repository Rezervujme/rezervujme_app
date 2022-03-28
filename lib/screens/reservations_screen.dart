import 'package:flutter/material.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  List<String> notifications = List.filled(4, 'Rezervácia', growable: true);

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
        itemCount: notifications.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          print(notifications);
          return ListTile(
            title: Text(notifications[index]),
            subtitle: Text('12. marec 2022, 13:30'),
          );
        },
      ),
    );
  }
}
