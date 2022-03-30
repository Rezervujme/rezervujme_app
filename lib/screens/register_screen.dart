import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rezervujme_app/state/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _currentPin = '';
  String _name = '';
  String _surname = '';
  String _email = '';

  void _verifyPin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<AuthCubit>().register(
        context, widget.phoneNumber, _currentPin, _email, _name, _surname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrácia'),
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
                  'Registrácia',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Text(
                'Zadajte pin, ktorý sme zaslali na vaše telefónne číslo a vyplňte vaše údaje',
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
                      TextFormField(
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Meno',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5)),
                          floatingLabelStyle:
                              TextStyle(color: Colors.grey[700]),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.givenName],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Prosím zadajte meno';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Priezvisko',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5)),
                          floatingLabelStyle:
                              TextStyle(color: Colors.grey[700]),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.familyName],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Prosím zadajte priezvisko';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _surname = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Email',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.5)),
                          floatingLabelStyle:
                              TextStyle(color: Colors.grey[700]),
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
                                  .hasMatch(value)) {
                            return 'Prosím zadajte platný email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
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
                  onPressed: _currentPin.length == 6 &&
                          _name.isNotEmpty &&
                          _surname.isNotEmpty &&
                          _email.isNotEmpty
                      ? _verifyPin
                      : null,
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
