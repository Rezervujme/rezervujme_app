import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vrouter/vrouter.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final StreamController<ErrorAnimationType> _errorAnimationController =
      StreamController<ErrorAnimationType>();

  String _currentPin = '';

  void _verifyPin() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      print('error');
      print(_currentPin);

      _errorAnimationController.add(ErrorAnimationType.shake);
      return;
    }
    print(_currentPin);
    context.vRouter.to('/intro/register');

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
