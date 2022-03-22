import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _currentPin = '';

  void _verifyPin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<AuthCubit>().login(context, widget.phoneNumber, _currentPin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prihlásenie'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 8),
                child: Text(
                  'Prihlásenie',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Text(
                'Zadajte pin, ktorý sme zaslali na vaše telefónne číslo a prihláste sa',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PinCodeTextField(
                        cursorColor: Theme.of(context).primaryColor,
                        pinTheme: PinTheme(
                          activeColor: Colors.black,
                          selectedColor: Theme.of(context).primaryColor,
                          inactiveColor: Colors.grey,
                        ),
                        enablePinAutofill: true,
                        onChanged: (value) {
                          setState(() {
                            _currentPin = value;
                          });
                        },
                        validator: (pin) => pin?.length == 6 ? null : "",
                        length: 6,
                        appContext: context,
                        autoFocus: true,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32),
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: _currentPin.length == 6 ? _verifyPin : null,
                  child: const Text(
                    'Potvrdiť',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
