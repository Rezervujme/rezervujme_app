import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final StreamController<ErrorAnimationType> _errorAnimationController =
      StreamController<ErrorAnimationType>();

  String _currentPin = '';

  void _verifyPin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      print('error');
      print(_currentPin);

      _errorAnimationController.add(ErrorAnimationType.shake);
      return;
    }
    try {
      var data = await Dio().post(
          '${dotenv.get('APP_URL')}/api/v1/auth/sms/register/register',
          data: {"phone_number": widget.phoneNumber, "auth_code": _currentPin});
      print(data);
      // context.vRouter.to('/intro/register');
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
    print(_currentPin);

    // context.vRouter.to('/tabs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potvrdenie'),
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
                  'Potvrdenie',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Text(
                'Zadajte pin, ktorý sme zaslali na vaše telefónne číslo.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Form(
                  key: _formKey,
                  child: PinCodeTextField(
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
                    errorAnimationController: _errorAnimationController,
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
