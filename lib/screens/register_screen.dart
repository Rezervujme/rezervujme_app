import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  void _register() {
    print('test');
    if (_formKey.currentState!.validate()) {
      context.vRouter.to('/tabs');
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Meno',
                ),
                keyboardType: TextInputType.name,
                autofillHints: const [AutofillHints.givenName],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prosím zadajte meno';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Priezvisko',
                ),
                keyboardType: TextInputType.name,
                autofillHints: const [AutofillHints.familyName],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prosím zadajte priezvisko';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
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
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Zaregistrovať'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
