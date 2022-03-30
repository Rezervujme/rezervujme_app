import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nastavenia'),
      ),
      body: Column(
        children: [
          ListTile(
              title: const Text('Odhlásiť sa'),
              onTap: () async =>
                  await context.read<AuthCubit>().logout(context)),
        ],
      ),
    );
  }
}
