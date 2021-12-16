import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vrouter/vrouter.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Prihlásenie'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 32),
                child: SvgPicture.asset(
                  'assets/images/login.svg',
                  height: 150,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Prihlásenie',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Text(
                'Prosím zadajte vaše telefónne číslo.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Expanded(child: LoginForm()),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PhoneNumber _phoneNumber = PhoneNumber();

  void submitNumber() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    print(_phoneNumber.phoneNumber);
    context.vRouter.to('/intro/verify');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(right: 16, top: 16),
          child: InternationalPhoneNumberInput(
            cursorColor: Theme.of(context).primaryColor,
            spaceBetweenSelectorAndTextField: 8,
            initialValue: PhoneNumber(isoCode: 'SK'),
            inputDecoration: InputDecoration(
                hintText: '901 123 456',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.5))),
            onInputChanged: (number) {
              setState(() {
                _phoneNumber = number;
              });
            },
            onSubmit: submitNumber,
            errorMessage: 'Nesprávny formát telefónneho čísla',
          ),
        ),
      ),
      Expanded(
        child: Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 48,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: ElevatedButton(
                  child: const Text(
                    'Pokračovať',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: _phoneNumber.dialCode == _phoneNumber.phoneNumber
                      ? null
                      : submitNumber),
            )),
      ),
    ]);
  }
}
